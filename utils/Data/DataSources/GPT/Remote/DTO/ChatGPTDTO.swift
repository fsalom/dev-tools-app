//
//  ChatGPT.swift
//  chatgpt
//
//  Created by Fernando Salom Carratala on 11/5/23.
//

import Foundation

struct Model: Codable {
    var model: String
    var messages: [MessageDTO]
}

struct ChoiceDTO: Codable {
    var message: MessageDTO
}

struct ResponseDTO: Codable {
    var choices: [ChoiceDTO]
}
