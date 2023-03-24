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
        let openAIKey = ""

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openAIKey)"
        ]

        guard let url = URL(string: openAIEndpoint) else {
            throw ChatError.invalidURL
        }

        let parameters = ["model": "gpt-3.5-turbo",
                          "messages": [["role": "user",
                                        "content": prompt]]] as [String : Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let (data, response) = try await URLSession.shared.data(for: request)

        print(data)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ChatError.fail
        }
        print(response)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let completions = (json?["choices"] as? [[String: Any]])?.first?["text"] as? String ?? ""
        return completions
    }
}
