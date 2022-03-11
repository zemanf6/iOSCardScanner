//
//  HistoryCell.swift
//  CardScanner
//
//  Created by Filip Zeman on 11.03.2022.
//

import UIKit

class HistoryCell: UITableViewCell {

    var item = HistoryItem() {
        didSet {
            prepareData()
        }
    }

    private var nameLabel = UILabel()
    private var dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareView() {
        prepareNameLabel()
    }

    private func prepareData() {
        nameLabel.text = item.text
    }

    private func prepareNameLabel() {
        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func prepareDateLabel() {
        contentView.addSubview(dateLabel)
    }

}
