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
    @State private var checked: Bool = true
    @FocusState private var focusedField: Field?
    @Environment(\.managedObjectContext) private var viewContext

    private enum Field: Int, CaseIterable {
            case url
        }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Introduce la ruta")
                .fontWeight(.bold)
                .font(.title2)
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
                        .stroke(url.isEmpty ? Color.black : Color.green, lineWidth: 2)
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
            }.padding(.bottom, 50)

            if let element = viewModel.element {
                if let content = element.content {
                    List(content, children: \.content) { row in
                        HStack {
                            let type = row.type != .array ? "(\(row.type))" : "[\(row.content?.count ?? 0)]"    
                            Text(row.name + " \(type)").fontWeight(.heavy)
                            Spacer()
                            if let value = row.value {
                                Text("\(value)").foregroundColor(.orange)
                            }
                        }
                    }.listStyle(.plain)
                }
            }
            HStack {
                Button(action: {
                  //Create files
                }, label: {
                  Text("Descargar")
                }).buttonStyle(GrowingButton())
            }
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading)
        .padding(30)
        .navigationTitle("Parseador de JSON")
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
