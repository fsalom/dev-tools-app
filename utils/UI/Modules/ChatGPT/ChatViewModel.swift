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

struct Message: Identifiable, Equatable {
    let id = UUID()
    var text: String
    let isSentByUser: Bool
    var state: MessageState
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
                let message = Message(text: "",
                                      isSentByUser: false,
                                      state: .loading)
                do {
                    messages.append(message)
                    let text = try await networkClient.send(this: prompt)
                    changeState(of: message.id, with: .success, and: text)
                } catch {
                    changeState(of: message.id, with: .error, and: error.localizedDescription)
                    print("text: \(error)")
                }
            }
        }

        func changeState(of identifier: UUID, with state: MessageState, and text: String) {
            if let row = self.messages.firstIndex(where: {$0.id == identifier}) {
                messages[row].state = state
                messages[row].text = text
            }
        }

        func createMessage() {
            let newMessage = Message(text: newMessageText,
                                     isSentByUser: true,
                                     state: .success)
            messages.append(newMessage)
            chatGPT(with: newMessageText)
            newMessageText = ""
        }

        func getString(_ string: String, between start: String, and end: String) -> String? {
            // Buscar el índice donde comienza el substring
            guard let startIndex = string.range(of: start)?.upperBound else {
                return nil
            }

            // Buscar el índice donde termina el substring
            guard let endIndex = string.range(of: end, range: startIndex..<string.endIndex)?.lowerBound else {
                return nil
            }

            // Obtener el substring
            let substring = string.substring(with: startIndex..<endIndex)
            return substring
        }
    }
}

