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
        prepareDateLabel()
    }

    private func prepareData() {
        nameLabel.text = item.text
        dateLabel.text = item.date
    }

    private func prepareNameLabel() {
        contentView.addSubview(nameLabel)

        nameLabel.font = .boldSystemFont(ofSize: 17)

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
    }

    private func prepareDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.textAlignment = .right
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 12)

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
        }
    }

}
