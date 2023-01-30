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

        func dataToJson(_ data: Data) throws -> [String:AnyObject]? {
            do {
                let json = try JSONSerialization.jsonObject(with: data,
                                                            options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                throw CommonError.parsingJSON
            }
        }

        func parse(this JSON: String) throws {
            if let data = JSON.data(using: .utf8) {
                do {
                    let json = try dataToJson(data)
                    let manager = JSONManager()
                    manager.parseJson(from: json as Any)
                    self.element = manager.root

                    let createFile = CreateFileManager()
                    try createFile.createClassesIOS(element: manager.root, result: "")
                } catch {
                    throw error
                }
            }
        }
    }
}
