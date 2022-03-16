//
//  HistoryItem.swift
//  CardScanner
//
//  Created by Filip Zeman on 03.12.2021.
//

import Foundation
import RealmSwift

class HistoryItem: Object {
    @objc var text = String()
    @objc var date = String()
    @objc var code = String()
}
