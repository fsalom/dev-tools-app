//
//  JsonParserRepository.swift
//  utils
//
//  Created by Fernando Salom Carratala on 18/12/23.
//

import Foundation

class JsonParserRepository: JsonParserRepositoryProtocol {
    var datasource: JsonParserDataSourceProtocol

    init(datasource: JsonParserDataSourceProtocol) {
        self.datasource = datasource
    }

    func getLevels(from json: Any) -> Element {
        datasource.parse(json: json)
    }
}
