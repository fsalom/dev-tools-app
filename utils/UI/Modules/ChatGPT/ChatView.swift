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
                            if message.isSentByUser { Spacer(minLength: 200.0) }
                            setStateView(for: message)
                            if !message.isSentByUser { Spacer(minLength: 200.0) }
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
            return AnyView(
                VStack {
                    ForEach(message.contents.indices, id: \.self) { index in
                        let content = message.contents[index]
                        if content.type == .text {
                            if message.isSentByUser {
                                Text(content.text)
                                    .padding(8)
                                    .textSelection(.enabled)
                            } else {
                                Text(content.text)
                                    .padding(8)
                                    .textSelection(.enabled)
                                    .frame(maxWidth: .infinity, alignment: message.isSentByUser ? .trailing : .leading)
                            }
                        } else if content.type == .code {
                            Text(content.text)
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .textSelection(.enabled)
                                .cornerRadius(10)
                        }
                    }
                }.foregroundColor(.white)
                    .background(message.isSentByUser ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .id(message.id)
                    .padding(10))

        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
