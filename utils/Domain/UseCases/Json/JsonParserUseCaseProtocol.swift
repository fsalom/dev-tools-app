//
//  JsonParserUseCaseProtocol.swift
//  utils
//
//  Created by Fernando Salom Carratala on 18/12/23.
//

import Foundation

protocol JsonParserUseCaseProtocol {
    func getLevels(from json: Any) -> Element
}
