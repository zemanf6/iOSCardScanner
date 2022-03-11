//
//  LogoColor.swift
//  CardScanner
//
//  Created by Filip Zeman on 10.03.2022.
//

import Foundation
import UIKit

class logoColor: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        self.addTarget(self, action: #selector(imageButtonClicked), for: .touchUpInside)

        let config = UIImage.SymbolConfiguration(pointSize: 27)

        self.setImage(UIImage(systemName: "circle.fill", withConfiguration: config), for: .normal)

        self.tintColor = .green
    }

    var colors: [UIColor] = [.green, .red, .blue, .yellow, .white]
    var selectedColor = 0

    @objc private func imageButtonClicked() {
        if selectedColor == colors.count - 1 {
            selectedColor = 0
            self.tintColor = colors[0]
        }
        else {
            selectedColor += 1
            self.tintColor = colors[selectedColor]
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
