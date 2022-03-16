//
//  ShowedViewController.swift
//  CardScanner
//
//  Created by Filip Zeman on 18.11.2021.
//

import UIKit
import SnapKit

class ShowedViewController: UIViewController {
    
    private let edgeConstraint = 15
    private let heightConstraint = 135.0
    private var topConstraint = 40
    var code = String()
    private var scrollView = UIScrollView()
    private var bottomConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .paleGreySix
        prepareScrollView()
        mapCells()
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
    var decoded = CellModelArray()
    private func mapCells() {
        print(decoded)
        var counter = 0
        var shouldContinue = false

        self.title = decoded.name
        for c in decoded.cells ?? [] {
            if c.id == 0 { //Half
                if !shouldContinue {
                    addHalfView(ltitle: c.title, ldescription: c.description, rtitle: decoded.cells?[counter + 1].title ?? "", rdescription: decoded.cells?[counter + 1].description ?? "", lcolor: c.color, rcolor: decoded.cells?[counter + 1].color ?? 0)

                    shouldContinue = true
                }
                else {
                    shouldContinue = false
                    continue
                }

            } else { //Full
                addFullView(title: c.title, description: c.description, color: c.color)
            }
            counter += 1
        }
    }

    let colors: [UIColor] = [.green, .red, .blue, .yellow, .white]
    private func addHalfView(ltitle: String, ldescription: String, rtitle: String, rdescription: String, lcolor: Int, rcolor: Int) {
        let halfCell = HalfCell()
        scrollView.addSubview(halfCell)

        bottomConstraint?.deactivate()
        halfCell.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgeConstraint)
            make.trailing.equalToSuperview().offset(-210)
            make.top.equalToSuperview().offset(topConstraint)
            make.height.equalTo(heightConstraint)
            bottomConstraint = make.bottom.equalToSuperview().constraint
        }

        let halfCell2 = HalfCell()
        scrollView.addSubview(halfCell2)
        halfCell2.snp.makeConstraints { make in
            make.leading.equalTo(halfCell.snp.trailing).offset(27)
            make.trailing.equalToSuperview().offset(-edgeConstraint)
            make.top.equalToSuperview().offset(topConstraint)
            make.height.equalTo(heightConstraint)
        }

        halfCell.headerTextField.text = ltitle
        halfCell.detailTextField.text = ldescription

        halfCell2.headerTextField.text = rtitle
        halfCell2.detailTextField.text = rdescription


        halfCell.logoButton.tintColor = colors[lcolor]
        halfCell2.logoButton.tintColor = colors[rcolor]

        halfCell.detailTextField.isEditable = false
        halfCell.logoButton.isEnabled = false
        halfCell.headerTextField.isEnabled = false

        halfCell2.detailTextField.isEditable = false
        halfCell2.logoButton.isEnabled = false
        halfCell2.headerTextField.isEnabled = false

        topConstraint += 155
    }

    private func addFullView(title: String, description: String, color: Int) {
        let fullCell = FullCell()
        scrollView.addSubview(fullCell)

        bottomConstraint?.deactivate()
        fullCell.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgeConstraint)
            make.trailing.equalToSuperview().offset(-edgeConstraint)
            make.top.equalToSuperview().offset(topConstraint)
            make.height.equalTo(heightConstraint * 1.3)
            bottomConstraint = make.bottom.equalToSuperview().constraint
        }

        topConstraint += 195
        
        fullCell.headerTextField.text = title
        fullCell.detailTextField.text = description

        fullCell.logoButton.tintColor = colors[color]

        fullCell.logoButton.isEnabled = false
        fullCell.detailTextField.isEditable = false
        fullCell.headerTextField.isEnabled = false
    }

}
