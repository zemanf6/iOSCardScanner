//
//  ShowedViewController.swift
//  CardScanner
//
//  Created by Filip Zeman on 18.11.2021.
//

import UIKit

class ShowedViewController: UIViewController {

    var code = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let ac = UIAlertController(title: "Scanned!", message: code, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}
