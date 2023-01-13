//
//  JsonParserView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/1/23.
//

import SwiftUI

struct JsonParserView: View {
    @StateObject private var viewModel = JsonParserViewModel()
    @State private var url: String = ""    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack(alignment: .leading) {
            Section(header: Text("Introduce la ruta")) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    TextField("añadir url", text: $url).padding(20)
                        .foregroundColor(.accentColor)
                        .cornerRadius(10)
                        .onSubmit {
                            viewModel.text = ""
                            viewModel.getJSON(for: url)
                        }
                }
            }
            ScrollView {
                VStack {
                  Text(viewModel.text)
                }
            }
            /*ZStack {
                TextEditor(text: $viewModel.text)
                    .font(.custom("SourceCodePro", size: 16.0))
                    .border(.black, width: 1.0)
            }*/
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading)
        .padding(30)
    }
}

struct JsonParserView_Previews: PreviewProvider {
    static var previews: some View {
        JsonParserView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct TextViewWrapper: UIViewRepresentable {
    var attributedText: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()

        uiView.backgroundColor = .clear
        uiView.textContainerInset = .zero
        uiView.isEditable = false
        uiView.isScrollEnabled = false
        uiView.textContainer.lineFragmentPadding = 0

        return uiView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
    }
}
