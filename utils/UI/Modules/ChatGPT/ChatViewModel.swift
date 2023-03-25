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
    }
}
