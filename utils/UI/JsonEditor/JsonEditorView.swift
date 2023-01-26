//
//  JsonEditorView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 20/1/23.
//

import SwiftUI

struct JsonEditorView: View {
    @StateObject private var viewModel = JsonEditorViewModel()
    @State private var text: String = ""
    @State private var errorMessage: String = ""
    @State var presentingModal = false
    @State private var width: CGFloat = 0
    @FocusState private var focusedField: Field?
    @Environment(\.openURL) private  var openURL
    @Environment(\.managedObjectContext) private var viewContext

    private enum Field: Int, CaseIterable {
        case url
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if errorMessage != "" {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ERROR")
                                    .bold()
                                Text(errorMessage)
                                    .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                            }
                        }
                        .foregroundColor(Color.white)
                        .padding(12)
                        .background(Color.red)
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation {
                                self.errorMessage = ""
                            }
                        }.onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    self.errorMessage = ""
                                }
                            }
                        })
                    }
                }
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Button {
                        do {
                            try viewModel.parse(this: text)
                        } catch {
                            if let message = error as? CommonError {
                                errorMessage = message.localizedDescription
                            }
                        }
                    } label: {
                        Text("Enviar")
                    }.buttonStyle(GrowingButton())
                }
                TextEditor(text: $text)
                    .padding(15)
                    .font(.system(size: 16, weight: .bold))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))

                if let element = viewModel.element {
                    if let content = element.content {
                        List(content, children: \.content) { row in
                            HStack {
                                let type = row.type != .array ? "(\(row.type))" : "[\(row.content?.count ?? 0)]"
                                Text(row.name + " \(type)").fontWeight(.heavy)
                                Spacer()
                                if let value = row.value {
                                    if row.type == .string {
                                        if let urlString = value as? String, urlString.canOpenUrl() {
                                            Link(urlString, destination: URL(string: urlString)!)
                                                .onTapGesture {
                                                    openURL(URL(string: urlString)!)
                                                }
                                                .foregroundColor(.blue)
                                            Image(systemName: "doc.on.doc.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20.0)
                                                .onTapGesture {
                                                    self.presentingModal = true
                                                    UIPasteboard.general.string = urlString
                                                }
                                        } else {
                                            Text("\(value)").foregroundColor(.orange)
                                        }
                                    } else {
                                        Text("\(value)").foregroundColor(.orange)
                                    }
                                }
                            }
                        }.listStyle(.plain)
                    }
                }
                HStack {
                    Button {

                    } label: {
                        Text("Descargar para Xcode")
                    }.buttonStyle(GrowingButton())
                    Spacer()
                    Button {

                    } label: {
                        Text("Descargar para Android")
                    }.buttonStyle(GrowingButton())
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            .navigationTitle("Parseador de JSON")
            if presentingModal {
                FloatingNotice(showingNotice: $presentingModal)
            }
        }
    }
}

struct JsonEditorView_Previews: PreviewProvider {
    static var previews: some View {
        JsonParserView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
