//
//  JSONParserProtocol.swift
//  utils
//
//  Created by Fernando Salom Carratala on 18/12/23.
//

import Foundation

protocol JsonParserDataSourceProtocol {
    func parse(json: Any) -> Element
}
