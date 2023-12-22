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
        @Published var element: Element?
        var networkClient: NetworkClientJSONProtocol

        init() {
            networkClient = NetworkClientJSON()
        }

        func getJSON(for url: String) throws {
            guard let url = URL(string: url) else { throw CommonError.invalidURL }
            Task {
                self.isLoading = true
                do {
                    let (_, data) = try await networkClient.getJSONStringAndData(for: url)
                    do {
                        let resultJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        let manager = JsonManager()
                        manager.parseJson(from: resultJson as Any)
                        self.element = manager.root
                    } catch {
                        throw CommonError.parsingURL
                    }
                } catch {
                    throw CommonError.networkFailed
                }
                self.isLoading = false
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

