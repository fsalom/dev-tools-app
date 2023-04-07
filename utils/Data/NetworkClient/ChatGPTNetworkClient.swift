//
//  ChatGPTNetworkClient.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/3/23.
//

import Foundation

protocol ChatGPTNetworkClientProtocol {
    func send(this prompt: String, and messages: [MessageDTO]) async throws -> MessageDTO?
}

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

final class ChatGPTNetworkClient: ChatGPTNetworkClientProtocol {
    enum ChatError: Error {
        case invalidURL
        case fail
    }

    func send(this prompt: String, and messages: [MessageDTO]) async throws -> MessageDTO? {
        let openaiAPIKey = Keys.chatGPT.value
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        /*
        let parameters = ["model": "gpt-3.5-turbo",
                          "messages": try JSONEncoder().encode(messages)
        ] as [String : Any]*/
        let parameters = Model(model: "gpt-3.5-turbo", messages: messages)
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openaiAPIKey)"
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONEncoder().encode(parameters)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "error", code: 0, userInfo: nil)
        }

        let decoder = JSONDecoder()
        do {
            let parseData = try decoder.decode(ResponseDTO.self, from: data)
            print(parseData)
            return parseData.choices.first?.message
        } catch {
            print(error)
            throw ChatError.fail
        }
    }
}
