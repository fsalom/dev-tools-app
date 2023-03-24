//
//  ChatView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/3/23.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isSentByUser: Bool
}

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if message.isSentByUser {
                            Spacer()
                        }
                        Text(message.text)
                            .padding()
                            .foregroundColor(.white)
                            .background(message.isSentByUser ? Color.blue : Color.green)
                            .cornerRadius(10)
                        if !message.isSentByUser {
                            Spacer()
                        }
                    }
                }
            }
            HStack {
                TextField("Escribe aquí...", text: $viewModel.newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Enviar") {
                    let newMessage = Message(text: viewModel.newMessageText, isSentByUser: true)
                    viewModel.messages.append(newMessage)
                    viewModel.chatGPT(with: viewModel.newMessageText)
                    viewModel.newMessageText = ""
                }
                .disabled(viewModel.newMessageText.isEmpty)
            }
            .padding()
        }.padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
