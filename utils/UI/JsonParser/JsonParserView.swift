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
                if let element = viewModel.element {
                    if let content = element.content {
                        List(content, children: \.content) { row in
                            HStack {
                                Text(row.name)
                                if let value = row.value {
                                    Text("\(value)")
                                }
                            }
                        }
                    }
                }
            }
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading)
        .padding(30)
    }

    /*
    func addNewElement(for node: Element) -> some View {
        Group {
            VStack(alignment: .leading) {
                Text(node.name)
                if let child = node.child {
                    Text(child.name)
                    //addNewElement(for: child)
                }
                if let content = node.content {
                    if content.count > 0 {
                        ForEach(content) { property in
                            HStack {
                                Text(property.name)
                                if let value = property.value {
                                    Text("\(value)")
                                }
                            }
                        }
                    }
                    //ForEach(node.content) { property in}
                    //addNewElement(for: child)
                }
            }
        }
    }
     */
}

struct JsonParserView_Previews: PreviewProvider {
    static var previews: some View {
        JsonParserView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct CheckBoxView: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    struct CheckBoxViewHolder: View {
        @State var checked = false

        var body: some View {
            CheckBoxView(checked: $checked)
        }
    }

    static var previews: some View {
        CheckBoxViewHolder()
    }
}
