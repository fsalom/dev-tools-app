//
//  DateFormatterView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/1/23.
//

import SwiftUI

struct DateFormatterView: View {
    @StateObject private var viewModel = DateFormatterViewModel()
    @FocusState private var focusedField: Field?
    @Environment(\.openURL) private  var openURL
    @Environment(\.managedObjectContext) private var viewContext

    private enum Field: Int, CaseIterable {
        case url
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Fecha:").frame(width: 100)
                TextField("Añade tu fecha", text: $viewModel.date)
                    .textFieldStyle(RoundTextFieldModifier())
                Button("Ahora") {
                    viewModel.date = String(Date().timeIntervalSince1970)
                }.buttonStyle(GrowingButton())
            }
            HStack {
                Text("Formato:").frame(width: 100)
                TextField("Añade el formato para la fecha. Ejemplo: Y-m-d", text: $viewModel.formatDate)
                    .textFieldStyle(RoundTextFieldModifier())
            }
            HStack {
                Text(viewModel.resultDate)
                    .padding(15)
                    .font(.system(size: 30, weight: .bold))
            }
            HStack {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                Button {

                } label: {
                    Text("Enviar")
                }.buttonStyle(GrowingButton())
            }
        }
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
        .navigationTitle("Formateador de fecha")
        Spacer() 
    }
}

struct DateFormatterView_Previews: PreviewProvider {
    static var previews: some View {
        JsonParserView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
