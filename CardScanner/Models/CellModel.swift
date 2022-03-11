//
//  HalfCellModel.swift
//  CardScanner
//
//  Created by Filip Zeman on 09.02.2022.
//

import Foundation

class CellModel: Codable {

    var id: Int
    var title: String
    var description: String
    var color: Int

    init(id: Int, title: String, description: String, color: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.color = color
    }
}

class CellModelArray: Codable {

    var cells: [CellModel]?
    var name: String?

}
