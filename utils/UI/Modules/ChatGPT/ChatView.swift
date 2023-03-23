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
    @State private var newMessageText = ""
    @State private var messages: [Message] = [
        Message(text: "Hola, ¿cómo estás?", isSentByUser: false),
        Message(text: "Estoy bien, gracias. ¿Y tú?", isSentByUser: true),
        Message(text: "Estoy bien también, gracias.", isSentByUser: false)
    ]

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
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
                TextField("Escribe aquí...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Enviar") {
                    let newMessage = Message(text: newMessageText, isSentByUser: true)
                    messages.append(newMessage)
                    newMessageText = ""
                }
                .disabled(newMessageText.isEmpty)
            }
            .padding()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
