//
//  GPTDataSource.swift
//  chatgpt
//
//  Created by Fernando Salom Carratala on 11/5/23.
//

import Foundation
import TripleA

enum GPTError: Error {
    case custom(String, String)

    var localizedDescription: String {
        switch self {
        case .custom(let string, _):
            return string
        }
    }
}

class GPTDataSource: GPTDataSourceProtocol {
    var network: Network
    var apiKey: String

    init(network: Network, apiKey: String) {
        self.network = network
        self.apiKey = apiKey
    }

    func send(this prompt: String, and context: [MessageDTO]) async throws -> MessageDTO? {
        do {
            let openaiAPIKey = Keys.chatGPT.value
            let parameters = Model(model: "gpt-3.5-turbo", messages: context)
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
            let endpoint = Endpoint(path: "completions",
                                    httpMethod: .post,
                                    body: try? JSONEncoder().encode(parameters),
                                    headers: headers)
            let response = try await self.network.load(endpoint: endpoint,
                                                       of: ResponseDTO.self)
            return response.choices.first?.message
        } catch {
            guard let gptError = error as? NetworkError else { throw error }
            let decoder = JSONDecoder()
            switch gptError {
            case .failure(_, let data, _):
                guard let data else { throw error }
                let response = try decoder.decode(ErrorDTO.self, from: data)
                throw GPTError.custom(response.error.message, response.error.code)
            default:
                throw error
            }
        }
    }
}
