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
        @Published var text: AttributedString = ""
        var networkClient: NetworkClientJSONProtocol

        init() {
            networkClient = NetworkClientJSON()
        }

        func getJSON(for url: String) {
            guard let url = URL(string: url) else { return }
            Task {
                self.isLoading = true
                let (json, data) = try await networkClient.getJSONStringAndData(for: url)
                self.text = customize(this: json)
                do {
                    let resultJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                    let manager = JSONManager()
                    manager.parseJson(from: resultJson as Any)
                    print(manager.root)
                } catch {
                    print("Error -> \(error)")
                }
                self.isLoading = false
            }
        }

        func getKeysAndValues(of json: [String:AnyObject]) async {
            for (key, value) in json {
                if value is NSNumber || value is String || value is Bool {
                    print(key)
                    print(value)
                }
            }
        }


        func customize(this json: String) -> AttributedString {
            let jsonArray = json.split(separator: "\n")
            var myText: AttributedString = ""
            for line in jsonArray {
                var lineWithAttributed = AttributedString(stringLiteral: String(line))
                var container = AttributeContainer()
                container.foregroundColor = .red
                lineWithAttributed.mergeAttributes(container)
                myText.append(lineWithAttributed+"\n")
            }
            return myText
        }

    }
}

