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
    @State private var headers = [Header]()
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
                VStack{
                    if self.headers.count == 0 {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Button {
                                self.headers.append(Header(key: "", value: ""))
                            } label: {
                                Text("Añadir headers")
                            }.buttonStyle(GrowingButton())
                        }
                    }else{
                        ForEach(self.$headers){ $header in
                            VStack(alignment: .leading){
                                HStack{
                                    TextField("Clave", text: $header.key)
                                        .padding(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                    TextField("Valor", text: $header.value)
                                        .padding(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))

                                    Button {
                                        self.headers.removeAll { header in
                                            header.id == $header.id
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width: 40.0, height: 40.0)
                                    }

                                }
                            }
                        }
                    }
                }.padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(width: 40.0, height: 40.0)
                    }else{
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                    }
                    TextField("añadir url", text: $url)
                        .padding(15)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(url.isEmpty ? Color.gray : Color.green, lineWidth: 2)
                        )
                        .onSubmit {
                            viewModel.text = ""
                            viewModel.getJSON(for: url)
                            focusedField = nil
                        }.focused($focusedField, equals: .url)
                    Button(action: {
                        viewModel.text = ""
                        viewModel.getJSON(for: url)
                        focusedField = nil
                    }, label: {
                        Text("Obtener")
                    }).buttonStyle(GrowingButton())
                }.padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))

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
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading)
            .navigationTitle("Parseador de JSON")
            if presentingModal {
                FloatingNotice(showingNotice: $presentingModal)
            }
        }
    }
}

struct JsonParserView_Previews: PreviewProvider {
    static var previews: some View {
        JsonParserView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background()
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
            .shadow(radius: 10)
    }
}
