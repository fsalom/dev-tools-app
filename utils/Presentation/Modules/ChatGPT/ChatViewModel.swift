//
//  ChatViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/3/23.
//

import Foundation

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

