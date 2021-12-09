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

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    private var cameraView = UIView()

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

        let manualEnter = UIBarButtonItem(image: UIImage(systemName: "chart.bar.doc.horizontal"), style: .plain, target: self, action: #selector(manualEnterClick))

        navigationItem.rightBarButtonItems = [history, manualEnter]
    }

    @objc private func manualEnterClick() {
        let alert = UIAlertController(title: "add manually", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "QR Code"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields?[0]
            self.found(code: textField?.text ?? "")
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func found(code: String) {
        let showedViewController = ShowedViewController()
        showedViewController.code = code

        let historyItem = HistoryItem()
        historyItem.text = code

        let realm = try! Realm()

        try! realm.write({
            realm.add(historyItem)
        })

        navigationController?.pushViewController(showedViewController, animated: true)

        print(code)
    }

    @objc private func historyClick() {
        let historyController = HistoryViewController()

        navigationController?.pushViewController(historyController, animated: true)
    }

}

