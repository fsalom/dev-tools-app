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

struct MessageDTO: Codable {
    var content: String
    var attributed: AttributedString?
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

    func send(this prompt: String) async throws -> String {
        let openaiAPIKey = Keys.chatGPT.value
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let parameters = ["model": "gpt-3.5-turbo",
                          "messages": [
                            ["role": "user",
                             "content": prompt]
                          ]
        ] as [String : Any]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openaiAPIKey)"
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "error", code: 0, userInfo: nil)
        }

        let decoder = JSONDecoder()
        do {
            let parseData = try decoder.decode(ResponseDTO.self, from: data)
            print(parseData)
            print(getString(parseData.choices.first?.message.content ?? "", between: "```", and: "```"))
            return parseData.choices.first?.message.content ?? "---"
        } catch {
            print(error)
            throw ChatError.fail
        }
    }

    func getString(_ string: String, between start: String, and end: String) -> String? {
        // Buscar el índice donde comienza el substring
        guard let startIndex = string.range(of: start)?.upperBound else {
            return nil
        }

        // Buscar el índice donde termina el substring
        guard let endIndex = string.range(of: end, range: startIndex..<string.endIndex)?.lowerBound else {
            return nil
        }

        // Obtener el substring
        let substring = string.substring(with: startIndex..<endIndex)
        return substring
    }
}
