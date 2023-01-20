//
//  JsonEditorViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 20/1/23.
//

import Foundation

extension JsonEditorView {
    @MainActor class JsonEditorViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var text: AttributedString = ""
        @Published var element: Element?
        var networkClient: NetworkClientJSONProtocol

        init() {
            networkClient = NetworkClientJSON()
        }

        func parse(this JSON: String) {
            do {
                let encoder = JSONEncoder()
                if let jsonData = try? encoder.encode(JSON) {
                    let resultJson = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:AnyObject]
                    let manager = JSONManager()
                    manager.parseJson(from: resultJson as Any)
                    print(manager.root)
                    self.element = manager.root
                }
            } catch {
                print("Error -> \(error)")
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

