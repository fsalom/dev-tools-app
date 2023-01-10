//
//  JsonParserView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/1/23.
//

import SwiftUI

struct JsonParserView: View {
    @StateObject private var viewModel = MenuViewModel()
    @Environment(\.managedObjectContext) private var viewContext

    @State var headers: String = ""
    @State var url: String = ""

    var body: some View {
        VStack(alignment: .leading) {
                Section(header: Text("Introduce la ruta")) {
                    TextField("añadir cabeceras", text: $headers).padding(20)
                        .foregroundColor(.accentColor)
                        .cornerRadius(10)
                    TextField("añadir url", text: $url).padding(20)
                        .foregroundColor(.accentColor)
                        .cornerRadius(10)
                }
                Button("Obtener JSON") {
                }.padding(20).buttonStyle(.borderedProminent)
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
