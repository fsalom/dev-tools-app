//
//  ErrorDTO.swift
//  chatgpt
//
//  Created by Fernando Salom Carratala on 25/5/23.
//

import Foundation

struct ErrorDTO: Codable {
    var error: ErrorContentDTO
}

struct ErrorContentDTO: Codable {
    var message: String
    var code: String
}
