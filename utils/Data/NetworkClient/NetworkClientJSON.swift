//
//  NetworkClientJSON.swift
//  utils
//
//  Created by Fernando Salom Carratala on 10/1/23.
//

import Foundation

protocol NetworkClientJSONProtocol {
    func getJSON(for url: URL) async throws -> String
}

final class NetworkClientJSON: NetworkClientJSONProtocol {
    func getJSON(for url: URL) async throws -> String {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data.prettyPrintedJSONString ?? "---"
    }
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
            let prettyPrintedString = String(data: data, encoding: .utf8)
        else { return nil }

        return prettyPrintedString
    }
}
