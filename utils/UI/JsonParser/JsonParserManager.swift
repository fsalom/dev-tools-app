//
//  JsonParserManager.swift
//  utils
//
//  Created by Fernando Salom Carratala on 13/1/23.
//

import Foundation



class JSONManager {
    var root = Element()

    enum TypeOf {
        case int
        case bool
        case string
        case float
        case array
        case json
        case unknown
    }

    class Element {
        var type: TypeOf = .unknown
        var name: String = ""
        var value: AnyObject? = nil
        var child: Element? = nil
        var content = [Element]()

        init() {}
    }

    func parseJson(from json: Any) {
        parseJson(from: json, current: root)
    }

    func parseJson(from json: Any, current: Element) {
        if let dict = json as? [String: Any]{
            for (key, value) in dict {
                let element = Element()
                element.name = key
                if let dict = value as? [String: Any]{
                    element.type = .json
                    current.content.append(element)
                    parseJson(from: dict, current: element)
                } else if value is Array<Any> {
                    element.type = .array
                    current.content.append(element)
                    parseJson(from: value, current: element)
                } else {
                    element.value = value as AnyObject
                    element.type = getType(of: value)
                    current.content.append(element)
                }
            }
        }
        if let array = json as? Array<Any> {
            for item in array {
                let child = Element()
                child.name = current.name + "_child"
                child.type = getType(of: item)
                current.content.append(child)
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
            return .json
        }
        return .unknown
    }
}
