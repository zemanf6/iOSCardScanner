//
//  HistoryViewController.swift
//  CardScanner
//
//  Created by Filip Zeman on 19.11.2021.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    private var tableView = UITableView()

    var items = [HistoryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let item = HistoryItem()

        item.text = "Ahoj"
        items.append(item)

        tableView.dataSource = self
        tableView.delegate = self

        prepareView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func prepareView() {
        prepareTableView()
    }

    private func prepareTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HistoryCell

        cell?.item = items[indexPath.row]

        return cell ?? HistoryCell()
    }



}
