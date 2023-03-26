//
//  ChatView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/3/23.
//

import SwiftUI

enum MessageState {
    case loading
    case error
    case success
}

struct Message: Identifiable {
    let id = UUID()
    var text: String
    let isSentByUser: Bool
    var state: MessageState
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
                        switch message.state {
                        case .loading:
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.5)
                            }.padding(10)
                                .background(Color.green)
                                .cornerRadius(10)
                        case .error:
                            Text("Se ha producido un erro")
                                .padding()
                                .foregroundColor(.red)
                                .background(message.isSentByUser ? Color.blue : Color.green)
                                .cornerRadius(10)
                        case .success:
                            Text(message.text)
                                .padding()
                                .foregroundColor(.white)
                                .background(message.isSentByUser ? Color.blue : Color.green)
                                .cornerRadius(10)
                        }

                        if !message.isSentByUser {
                            Spacer()
                        }
                    }
                }
            }
            HStack {
                TextField("Escribe aquí...",
                          text: $viewModel.newMessageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    viewModel.createMessage()
                }
                Button("Enviar") {
                    viewModel.createMessage()
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
