//
//  ChatGPTDTO.swift
//  utils
//
//  Created by Fernando Salom Carratala on 8/4/23.
//

import Foundation

struct Model: Codable {
    var model: String
    var messages: [MessageDTO]
}

struct MessageDTO: Codable {
    var role: String
    var content: String

    init(from message: Message) {
        role = message.role
        content = message.content
    }
}

struct ChoiceDTO: Codable {
    var message: MessageDTO
}

struct ResponseDTO: Codable {
    var choices: [ChoiceDTO]
}
