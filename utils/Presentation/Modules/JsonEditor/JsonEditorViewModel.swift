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
        var manager: JsonManager?

        enum EditorError: Error {
            case notParsedYet
        }

        init() {
            networkClient = NetworkClientJSON()
        }

        func isValid(this JSON: String) -> Bool {
            if JSON.isEmpty { return false }
            do {
                if let data = JSON.data(using: .utf8) {
                    try JSONSerialization.jsonObject(with: data,
                                                     options: .mutableContainers)
                    return true
                }else {
                    return false
                }
            } catch {
                return false
            }
        }

        func dataToJSON(with data: Data) throws -> [String:AnyObject]? {
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
                    let json = try dataToJSON(with: data)
                    manager = JsonManager()
                    guard let manager else { throw EditorError.notParsedYet }
                    manager.parseJson(from: json as Any)
                    self.element = manager.root                    
                } catch {
                    throw error
                }
            }
        }

        func createFile() throws {
            do {
                let createFile = CreateFileManager()
                guard let manager else { throw EditorError.notParsedYet }
                try createFile.createClassesIOS(element: manager.root, result: "")
            } catch {
                throw error
            }
        }
    }
}
