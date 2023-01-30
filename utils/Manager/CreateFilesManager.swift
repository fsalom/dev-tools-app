//
//  CreateFilesManager.swift
//  utils
//
//  Created by Fernando Salom Carratala on 29/1/23.
//

import Foundation

enum FileError: Error {
    case notcreated
}

class CreateFileManager {

    var filename = ""

    func createFile(with name: String) throws -> URL {
        let file = "\(name)DTO.swift"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            return dir.appendingPathComponent(file)
        }

        throw FileError.notcreated
    }

    func createClassesIOS(element: Element, result: String) {
        var pending = [Element]()
        var newResult = result

        if element.type == .dict {
            newResult.append("class \(element.name + "Class"): Mappable {\n")
            var itemsPerType = [String: [Element]]()

            if let content = element.content {
                for item in content {
                    var items = itemsPerType[item.type.rawValue] ?? [Element]()
                    items.append(item)
                    itemsPerType[item.type.rawValue] = items
                }
            }

            for (itemType, items) in itemsPerType {
                if itemType == "array" {
                    for item in items {
                        /*
                        if let child = item.child {
                            if child.type == .dictionary {
                                pending.append(child)
                                newResult.append("    var \(item.name) = [\(child.name)Class]()\n")
                            } else {
                                newResult.append("    var \(item.name) = [\(child.type)]()\n")
                            }
                        }
                         */
                    }
                } else if itemType == "dict" {
                    for item in items {
                        newResult.append("    var \(item.name): \(item.name)Class?\n")
                        pending.append(item)
                    }
                } else if itemType == "nil" {
                    /*
                    newResult.append("    //var \(item.name): \(item.type)?\n")
                     */
                } else {
                    /*
                    newResult.append("    var \(item.name): \(item.type)?\n")
                     */
                }
            }

            newResult.append("\n")
            newResult.append("    required init?(map: Map) {}\n")
            newResult.append("\n")
            newResult.append("    func mapping(map: Map) {\n")

            for (itemType, items) in itemsPerType {
                for item in items {
                    if let content = item.content {
                        if content.count > 0 || item.type != .array && item.type != .dict {
                            if item.type == nil {
                                newResult.append("        //\(item.name) <- map[\"\(item.name)\"]\n")
                            } else {
                                newResult.append("        \(item.name) <- map[\"\(item.name)\"]\n")
                            }
                        }
                    }
                }
            }

            newResult.append("    }\n")
            newResult.append("}\n")
            newResult.append("\n")

            do {
                let fileUrl = try self.createFile(with: element.name)
                do {
                    try newResult.write(to: fileUrl,
                                        atomically: false,
                                        encoding: .utf8)
                    for element in pending {
                        createClassesIOS(element: element, result: newResult)
                    }
                } catch {
                    print("ERROR WRITING FILE")
                }
            } catch {
                print("ERROR CREATING FILE")
            }
        }
    }
}

