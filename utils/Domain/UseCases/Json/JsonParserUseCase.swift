//
//  JsonParserUseCase.swift
//  utils
//
//  Created by Fernando Salom Carratala on 18/12/23.
//

import Foundation

class JsonParserUseCase: JsonParserUseCaseProtocol {
    var repository: JsonParserRepositoryProtocol

    init(repository: JsonParserRepositoryProtocol) {
        self.repository = repository
    }

    func getLevels(from json: Any) -> Element {
        let root = repository.getLevels(from: json)
        return root
    }
}
