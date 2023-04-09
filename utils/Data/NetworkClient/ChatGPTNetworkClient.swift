//
//  ChatGPTNetworkClient.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/3/23.
//

import Foundation
import TripleA

protocol ChatGPTNetworkClientProtocol {
    func send(this prompt: String, and messages: [MessageDTO]) async throws -> MessageDTO?
}

final class ChatGPTNetworkClient: ChatGPTNetworkClientProtocol {
    enum ChatError: Error {
        case invalidURL
        case fail
    }

    func send(this prompt: String, and messages: [MessageDTO]) async throws -> MessageDTO? {

        let openaiAPIKey = Keys.chatGPT.value
        let parameters = Model(model: "gpt-3.5-turbo", messages: messages)
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openaiAPIKey)"
        ]
        let endpoint = Endpoint(path: "https://api.openai.com/v1/chat/completions",
                                httpMethod: .post,
                                body: try? JSONEncoder().encode(parameters),
                                headers: headers)
        let response = try await Network(baseURL: "").load(endpoint: endpoint,
                                                of: ResponseDTO.self)
        return response.choices.first?.message
    }
}
