//
//  JSONManagerDataSource.swift
//  utils
//
//  Created by Fernando Salom Carratala on 18/12/23.
//

import Foundation

class JsonManagerDataSource: JsonParserDataSourceProtocol {
    var manager: JsonManager

    init(manager: JsonManager) {
        self.manager = manager
    }

    func parse(json: Any) -> Element {
        manager.parseJson(from: json)
        return manager.root
    }
}
