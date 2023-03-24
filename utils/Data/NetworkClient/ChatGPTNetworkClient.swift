//
//  ChatGPTNetworkClient.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/3/23.
//

import Foundation

protocol ChatGPTNetworkClientProtocol {
    func send(this prompt: String) async throws -> String
}

struct MessageGPT: Codable {
    var role: String
    var content: String
}

final class ChatGPTNetworkClient: ChatGPTNetworkClientProtocol {
    enum ChatError: Error {
        case invalidURL
        case fail
    }

    func send(this prompt: String) async throws -> String {
        let openAIEndpoint = "https://api.openai.com/v1/chat/completions"
        let openAIKey = "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"

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openAIKey)"
        ]

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [MessageGPT(role: "user", content: prompt)],
        ]

        guard let url = URL(string: openAIEndpoint) else {
            throw ChatError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = json["choices"] as? [[String: Any]],
           let text = choices.first?["text"] as? String {
            return text
        } else {
            throw ChatError.fail
        }
    }
}
