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
                do {
                    let text = try await networkClient.send(this: prompt)
                    let message = Message(text: text, isSentByUser: false)
                    print("text: \(text)")
                    messages.append(message)
                } catch {
                    print("text: \(error)")
                }
            }
        }
    }
}

