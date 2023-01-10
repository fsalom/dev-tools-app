//
//  JsonParserViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 10/1/23.
//

import Foundation

final class JsonParserViewModel: ObservableObject {
    var networkClient: NetworkClientJSONProtocol
    var text: String = ""

    init() {
        networkClient = NetworkClientJSON()
    }

    func getJSON(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        Task {
            let json = try? await networkClient.getJSON(for: url)
            self.text = json ?? "---"
        }
    }
}
