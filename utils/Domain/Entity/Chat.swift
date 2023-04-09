//
//  Chat.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/4/23.
//

import Foundation

enum MessageState {
    case loading
    case error
    case success
}

struct MessageContent {
    enum MessageType {
        case text
        case code
    }
    var text: String
    var type: MessageType
}

struct Message: Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    var contents: [MessageContent]
    let isSentByUser: Bool
    var state: MessageState
    var role: String
    var content: String

    mutating func evaluate(this text: String){
        let tokens = text.split(separator: "```")
        for (index, token) in tokens.enumerated() {
            contents.append(MessageContent(text: String(token),
                                           type: index % 2 == 0 ? .text : .code))
        }
    }

    init(isSentByUser: Bool, state: MessageState){
        self.isSentByUser = isSentByUser
        self.state = state
        self.contents = []
        self.role = ""
        self.content = ""
    }

    func getString(_ string: String,
                   between start: String,
                   and end: String) -> String? {
        guard let startIndex = string.range(of: start)?.upperBound else {
            return nil
        }
        guard let endIndex = string.range(of: end, range: startIndex..<string.endIndex)?.lowerBound else {
            return nil
        }
        let substring = string.substring(with: startIndex..<endIndex)
        return substring
    }

}
