//
//  CreatingViewController.swift
//  CardScanner
//
//  Created by Filip Zeman on 11.01.2022.
//

import UIKit

class CreatingViewController: UIViewController {
    private let edgeConstraint = 15
    private let heightConstraint = 135.0
    private var topConstraint = 40

    private var models = [CellModel]()

    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGreySix

        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        prepareScrollView()
        prepareTopButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentSize = CGSize(
            width: view.frame.size.width, height: view.frame.size.height - 150
        )
    }

    private func prepareScrollView() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        let span = UIView()
        span.backgroundColor = .clear
        scrollView.addSubview(span)

        span.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(self.scrollView)
        }
    }

    private func prepareTopButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.split.2x1"), style: .plain, target: self, action: #selector(addHalfView))

        var rightButtonItems = [UIBarButtonItem]()

        rightButtonItems.append(UIBarButtonItem(image: UIImage(systemName: "rectangle"), style: .plain, target: self, action: #selector(addFullView)))

        rightButtonItems.append(UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(createCard)))

        navigationItem.rightBarButtonItems = rightButtonItems

    }

    @objc private func addHalfView() {
        let halfCell = HalfCell()
        scrollView.addSubview(halfCell)

        halfCell.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgeConstraint)
            make.trailing.equalToSuperview().offset(-210)
            make.top.equalToSuperview().offset(topConstraint)
            make.height.equalTo(heightConstraint)
        }

        let halfCell2 = HalfCell()
        scrollView.addSubview(halfCell2)
        halfCell2.snp.makeConstraints { make in
            make.leading.equalTo(halfCell.snp.trailing).offset(27)
            make.trailing.equalToSuperview().offset(-edgeConstraint)
            make.top.equalToSuperview().offset(topConstraint)
            make.height.equalTo(heightConstraint)
        }

        topConstraint += 155
    }

    @objc private func addFullView() {
        let fullCell = FullCell()
        scrollView.addSubview(fullCell)
        
        fullCell.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgeConstraint)
            make.trailing.equalToSuperview().offset(-edgeConstraint)
            make.top.equalToSuperview().offset(topConstraint)
            make.height.equalTo(heightConstraint * 1.3)
        }

        topConstraint += 195
    }

    @objc private func createCard() {
        for i in scrollView.subviews {

            if i.isKind(of: HalfCell.self) {

                models.append(CellModel(id: 0, title: (i as? HalfCell)?.headerTextField.text ?? "", description: (i as? HalfCell)?.detailTextField.text ?? "", color: (i as? HalfCell)?.logoButton.selectedColor ?? 0))
            }
            else if i.isKind(of: FullCell.self) {
                models.append(CellModel(id: 1, title: (i as? FullCell)?.headerTextField.text ?? "", description: (i as? FullCell)?.detailTextField.text ?? "", color: (i as? FullCell)?.logoButton.selectedColor ?? 0))
            }
            else {
                continue
            }
        }

        let rootModel = CellModelArray()
        rootModel.cells = models
        let ac = UIAlertController(title: "Enter your name", message: "", preferredStyle: .alert)

        ac.addTextField { textField in
            textField.placeholder = "Your name"
        }

        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { button in
            self.completion(ac: ac, rootModel: rootModel)
        }))
        present(ac, animated: true, completion: nil)
    }

    private func completion(ac: UIAlertController, rootModel: CellModelArray) {
        do {
            rootModel.name = ac.textFields?.first?.text
            let jsonString = try JSONEncoder().encode(rootModel)
            print(String(data: jsonString, encoding: .utf8) ?? "")

            DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(self.generateQRCode(from: String(data: jsonString, encoding: .utf8) ?? "") ?? UIImage(), nil, nil, nil)
            }

            let acConfirm = UIAlertController(title: "Card created", message: "QR Code was saved to your gallery", preferredStyle: .alert)
            acConfirm.addAction(UIAlertAction(title: "OK", style: .default))
            present(acConfirm, animated: true, completion: nil)
        }
        catch {
            print(error)
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
//TODO

// History
    //Create new view for history cell
    //Add date and time
    //Difference between yours and others cards

// History Realms
//scrollview
//Scan QR Code by picture
//Gallery save
