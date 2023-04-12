//
//  ChatView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/3/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var filename = "Filename"
    @State var showFileChooser = false
    var body: some View {
        VStack {
            Text("Añadir fichero de reespaldo para la conversación")
            HStack {
                Text(filename)
                Button("select File")
                {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        self.filename = panel.url?.lastPathComponent ?? "<none>"
                    }
                }
            }
            .frame(maxWidth: .infinity)
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
                Button(action: {
                    viewModel.isRecording.toggle()
                    if viewModel.isRecording {
                        speechRecognizer.reset()
                        speechRecognizer.transcribe()
                    } else {
                        speechRecognizer.stopTranscribing()
                        viewModel.newMessageText = speechRecognizer.transcript
                        viewModel.createMessage()
                    }
                }) {
                    Image(systemName: viewModel.isRecording ? "mic.fill" : "mic")
                }.keyboardShortcut("x")
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
                VStack(alignment: .leading, spacing: 0) {
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
                            }
                        } else if content.type == .code {
                            ZStack(alignment: .leading) {
                                Color.gray
                                    .ignoresSafeArea()

                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.white)
                                    .padding()

                                VStack(spacing: 10, content: {
                                    Text(content.text)
                                        .foregroundColor(Color.black)
                                        .padding()

                                }).padding()
                            }
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
