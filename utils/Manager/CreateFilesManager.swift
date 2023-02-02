//
//  CreateFilesManager.swift
//  utils
//
//  Created by Fernando Salom Carratala on 29/1/23.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

enum FileError: Error {
    case notcreated
}

class CreateFileManager {
    var filename = ""
    var path: String?

    init() {
        self.getXcodeProjFolder {
        }
    }

    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory : ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    func getXcodeProjFolder(completion: () -> Void) {
        guard let type = UTType(tag: "xcodeproj", tagClass: .filenameExtension, conformingTo: .compositeContent) else { fatalError() }
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [type]
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            guard var components = panel.urls.first?.pathComponents else { return }
            guard let xcodeproj = components.last else { return }
            let projectName = xcodeproj.split(separator: ".")
            components.removeLast()
            components.append(String(projectName[0]))

            var componentsToData = components
            componentsToData.append("Data")
            componentsToData.append("DTO")

            let pathToDTO = componentsToData.joined(separator: "/")
            if directoryExistsAtPath(pathToDTO) {
                path = pathToDTO
            } else {
                do {
                    try FileManager.default.createDirectory(atPath: pathToDTO, withIntermediateDirectories: true)
                    path = pathToDTO
                } catch {
                    path = components.joined(separator: "/")
                }
            }

        }
    }

    func createFile(with name: String) throws -> URL {
        let file = "\(name)DTO.swift"
        if let path {
            let url = URL(filePath: path)
            return url.appendingPathComponent(file)
        } else {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                return dir.appendingPathComponent(file)
            }
            throw FileError.notcreated
        }
    }

    func createClassesIOS(element: Element, result: String) throws {
        var pending = [Element]()
        var newResult = result

        guard let _ = path else { throw CommonError.xcodeprojectNotSelected }

        if element.type == .dict {
            newResult.append("struct \(element.name.capitalized)DTO: Codable {\n")
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
                        if let childs = item.content, childs.count > 0 {
                            let child = childs[0]
                            if child.type == .dict {
                                if child.name.contains("[") {
                                    child.name = item.name
                                }
                                pending.append(child)
                                newResult.append("    var \(item.name) = [\(child.name.capitalized)DTO]()\n")
                            } else {
                                newResult.append("    var \(item.name) = [\(child.type.rawValue)]()\n")
                            }
                        }
                    }
                } else if itemType == "dict" {
                    for item in items {
                        newResult.append("    var \(item.name): \(item.name.capitalized)DTO?\n")
                        pending.append(item)
                    }
                } else if itemType == "nil" {
                    //newResult.append("    //var \(item.name): \(item.type)?\n")
                } else {
                    for item in items {
                        if item.type == .unknown {
                            newResult.append("    //var \(item.name): \(item.type.rawValue)?\n")
                        } else {
                            newResult.append("    var \(item.name): \(item.type.rawValue)?\n")
                        }
                    }
                }
            }

            newResult.append("}\n")
            newResult.append("\n")

            do {
                let fileUrl = try self.createFile(with: element.name)
                do {
                    try newResult.write(to: fileUrl,
                                        atomically: false,
                                        encoding: .utf8)
                    newResult = ""
                    for element in pending {
                        try createClassesIOS(element: element, result: newResult)
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

