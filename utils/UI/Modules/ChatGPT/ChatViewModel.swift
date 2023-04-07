//
//  ChatViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/3/23.
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

extension ChatView {
    @MainActor class ChatViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var newMessageText = ""
        @Published var messages: [Message] = []
        var networkClient: ChatGPTNetworkClientProtocol

        init() {
            networkClient = ChatGPTNetworkClient()
        }

        func chatGPT(with prompt: String) {
            Task {
                let message = Message(isSentByUser: false,
                                      state: .loading)
                do {
                    messages.append(message)
                    guard let chat = try await networkClient.send(this: prompt, and: getChatHistory()) else {
                        return
                    }
                    let index = messages.count - 1
                    messages[index].role = chat.role
                    messages[index].content = chat.content
                    changeState(of: message.id,
                                with: .success,
                                and: chat.content)
                } catch {
                    changeState(of: message.id,
                                with: .error,
                                and: error.localizedDescription)
                    print("text: \(error)")
                }
            }
        }

        func changeState(of identifier: UUID, with state: MessageState, and message: String) {
            if let row = self.messages.firstIndex(where: {$0.id == identifier}) {
                messages[row].state = state
                messages[row].evaluate(this: message)
            }
        }

        func createMessage() {
            var newMessage = Message(isSentByUser: true,
                                     state: .success)
            newMessage.role = "user"
            newMessage.content = newMessageText
            newMessage.contents = [MessageContent(text: newMessageText,
                                                  type: .text)]
            messages.append(newMessage)
            var responses = [MessageDTO]()
            chatGPT(with: newMessageText)
            newMessageText = ""
        }

        func getChatHistory() -> [MessageDTO] {
            var responses = [MessageDTO]()
            for message in messages {
                if !message.role.isEmpty {
                    responses.append(MessageDTO(from: message))
                }
                continue
            }
            return responses
        }
    }
}

