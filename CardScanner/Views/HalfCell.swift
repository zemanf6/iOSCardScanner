//
//  HalfCell.swift
//  CardScanner
//
//  Created by Filip Zeman on 11.01.2022.
//

import UIKit

class HalfCell: UIView, UITextFieldDelegate, UITextViewDelegate {
    var logoButton = logoColor()
    var headerTextField = UITextField()
    var detailTextField = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        headerTextField.delegate = self
        detailTextField.delegate = self

        self.layer.cornerRadius = 10
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareView() {
        prepareLogoButton()
        prepareHeaderTextField()
        prepareDetailTextField()
    }

    private func prepareLogoButton() {
        self.addSubview(logoButton)

        logoButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(15)
        }

        let config = UIImage.SymbolConfiguration(pointSize: 23)
        logoButton.setImage(UIImage(systemName: "circle.fill", withConfiguration: config), for: .normal)

        logoButton.tintColor = .green
    }

    private func prepareHeaderTextField() {
        self.addSubview(headerTextField)
        headerTextField.text = "Header"
        headerTextField.font = .boldSystemFont(ofSize: 18)

        headerTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(logoButton.snp.trailing).offset(10)
            make.height.equalTo(27)
        }
    }

    private func prepareDetailTextField() {
        self.addSubview(detailTextField)
        detailTextField.text = "Description"
        detailTextField.font = .systemFont(ofSize: 16)
        detailTextField.textAlignment = .center

        detailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoButton.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-35)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 < 10 {
            return true
        } else {
            textField.deleteBackward()
            return false
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text?.count ?? 0 < 40 {
            return true
        } else {
            textView.deleteBackward()
            return false
        }
    }
}
