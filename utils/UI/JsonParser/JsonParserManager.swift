//
//  JsonParserManager.swift
//  utils
//
//  Created by Fernando Salom Carratala on 13/1/23.
//

import Foundation

class Element: Identifiable {
    var id = UUID()
    var type: TypeOf = .unknown
    var name: String = ""
    var value: NSObject? = nil
    var content: [Element]?

    init() {}
}

enum TypeOf: String {
    case int = "int"
    case bool = "bool"
    case string = "string"
    case float = "float"
    case array = "array"
    case dict = "dict"
    case unknown = "unknown"
}

class JSONManager {
    var root = Element()

    func parseJson(from json: Any) {
        parseJson(from: json, current: root)
    }

    func parseJson(from json: Any, current: Element) {
        if let dict = json as? [String: Any]{
            current.type = .dict
            current.content = []
            for (key, value) in dict {
                let element = Element()
                element.name = key
                if let dict = value as? [String: Any]{
                    element.type = .dict
                    current.content?.append(element)
                    parseJson(from: dict, current: element)
                } else if value is Array<Any> {
                    element.type = .array
                    current.content?.append(element)
                    parseJson(from: value, current: element)
                } else {
                    element.value = value as? NSObject
                    element.type = getType(of: value)
                    current.content?.append(element)
                }
            }
        }
        if let array = json as? Array<Any> {
            current.content = []
            for (index, item) in array.enumerated() {
                let child = Element()
                child.name = "[\(index)]"
                child.type = getType(of: item)
                if child.type != .array && child.type != .dict {
                    child.value = item  as? NSObject
                }
                current.content?.append(child)
                parseJson(from: item, current: child)
            }
        }
    }

    private func getType(of element: Any) -> TypeOf {
        if element is Int {
            return .int
        }
        if element is Bool {
            return .bool
        }
        if element is String {
            return .string
        }
        if element is Float {
            return .float
        }
        if element is [String: Any] {
            return .dict
        }
        return .unknown
    }
}
