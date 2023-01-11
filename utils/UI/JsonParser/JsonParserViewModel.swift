//
//  JsonParserViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 10/1/23.
//

import Foundation


extension JsonParserView {
    @MainActor class JsonParserViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var text: String = ""
        var networkClient: NetworkClientJSONProtocol

        init() {
            networkClient = NetworkClientJSON()
        }

        func getJSON(for url: String) {
            guard let url = URL(string: url) else {
                return
            }
            Task {
                self.isLoading = true
                let json = try? await networkClient.getJSON(for: url)
                self.text = json ?? "---"
                self.isLoading = false
            }
        }

    }
}
