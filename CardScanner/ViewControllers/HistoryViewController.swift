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

        items.reverse()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HistoryCell ?? HistoryCell()

        cell.item = items[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showedViewController = ShowedViewController()
        
        do {
            let decoded = try JSONDecoder().decode(CellModelArray.self, from: Data(items[indexPath.row].code.utf8))
            showedViewController.decoded = decoded
        }
        catch {
            print("error")
        }
        showedViewController.code = items[indexPath.row].code

        navigationController?.pushViewController(showedViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do {
            let realm = try Realm()

            try realm.write {
                let objects = realm.objects(HistoryItem.self).filter("text = %@ AND date = %@", items[indexPath.row].text, items[indexPath.row].date)

                realm.delete(objects)
            }
        } catch {
            print(error)
        }

        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
