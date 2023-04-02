//
//  ChatView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/3/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isSentByUser { Spacer() }
                            setStateView(for: message)
                            if !message.isSentByUser { Spacer() }
                        }
                    }
                    .onChange(of: viewModel.messages) { _ in
                        value.scrollTo(viewModel.messages.last?.id)
                    }
                }
            }
            HStack {
                TextField("Escribe aquí...",
                          text: $viewModel.newMessageText)
                .textFieldStyle(RoundTextFieldModifier())
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

    func setStateView(for message: Message) -> some View {
        switch message.state {
        case .loading:
            return AnyView(VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.5)
            }.padding(10)
                .background(Color.gray)
                .cornerRadius(10))
        case .error:
            return AnyView(Text("Se ha producido un error")
                .padding()
                .foregroundColor(.red)
                .background(message.isSentByUser ? Color.blue : Color.gray)
                .cornerRadius(10))
        case .success:
            return AnyView(Text(message.text)
                .padding()
                .textSelection(.enabled)
                .foregroundColor(.white)
                .background(message.isSentByUser ? Color.blue : Color.gray)
                .cornerRadius(10)
                .id(message.id))
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
