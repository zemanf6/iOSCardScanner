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

    var items: [HistoryItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()

        items?.append(contentsOf: realm.objects(HistoryItem.self))

        tableView.dataSource = self
        tableView.delegate = self
        prepareView()
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
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = items?[indexPath.row].text

        return cell
    }



}
