//
//  ViewController.swift
//  CardScanner
//
//  Created by Filip Zeman on 18.11.2021.
//

import UIKit
import AVFoundation
import SnapKit
import RealmSwift

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBarButtons()
        prepareAVLayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private func prepareAVLayer() {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if ((captureSession?.canAddInput(videoInput)) != nil) {
            captureSession?.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if ((captureSession?.canAddOutput(metadataOutput)) != nil) {
            captureSession?.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession ?? AVCaptureSession())
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer ?? AVCaptureVideoPreviewLayer())

        captureSession?.startRunning()
    }

    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    private func prepareBarButtons() {
        let history = UIBarButtonItem(image: UIImage(systemName: "clock"), style: .plain, target: self, action: #selector(historyClick))

        let gallerySelection = UIBarButtonItem(image: UIImage(systemName: "photo.fill.on.rectangle.fill"), style: .plain, target: self, action: #selector(galleryClick))

        navigationItem.rightBarButtonItems = [history, gallerySelection]
    }

    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features

        }
        return nil
    }

    @objc private func galleryClick() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let features = detectQRCode(image), !features.isEmpty{
                for case let row as CIQRCodeFeature in features{
                    found(code: row.messageString ?? "")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    private func found(code: String) {
        let showedViewController = ShowedViewController()
        showedViewController.code = code

        let historyItem = HistoryItem()

        do {
            let decoded = try JSONDecoder().decode(CellModelArray.self, from: Data(code.utf8))
            showedViewController.decoded = decoded
            historyItem.text = decoded.name ?? ""
        }
        catch {
            print("error")
        }

        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        historyItem.date = timestamp
        
        historyItem.code = code


        do {
            let realm = try Realm()

            try realm.write({
                realm.add(historyItem)
            })
        } catch {
            print(error)
        }

        navigationController?.pushViewController(showedViewController, animated: true)
    }

    private var historyController = HistoryViewController()

    @objc private func historyClick() {
        do {
            let realm = try Realm()

            let swiftArrayText = (realm.objects(HistoryItem.self).value(forKey: "text") as? NSArray ?? NSArray()).compactMap({ $0 as? String })
            let swiftArrayCode = (realm.objects(HistoryItem.self).value(forKey: "code") as? NSArray ?? NSArray()).compactMap({ $0 as? String })
            let swiftArrayDate = (realm.objects(HistoryItem.self).value(forKey: "date") as? NSArray ?? NSArray()).compactMap({ $0 as? String })

            for i in swiftArrayText {
                let historyItem = HistoryItem()
                historyItem.text = i
                historyController.items.append(historyItem)
            }

            var counter = 0
            for i in swiftArrayCode {
                historyController.items[counter].code = i
                counter += 1
            }
            counter = 0

            for i in swiftArrayDate {
                historyController.items[counter].date = i
                counter += 1
            }

        } catch {
            print(error)
        }

        navigationController?.pushViewController(historyController, animated: true)
    }

}
