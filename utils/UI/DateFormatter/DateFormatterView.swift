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
                Text("Fecha:")
                    .frame(width: 100, alignment: .leading)
                Image(systemName: "calendar.badge.clock")
                TextField("Añade tu fecha", text: $viewModel.date)
                    .textFieldStyle(RoundTextFieldModifier())
                Button("Ahora (timestamp)") {
                    viewModel.date = String(Date().timeIntervalSince1970)
                }.buttonStyle(GrowingButton())
            }
            HStack {
                Text("Formato:")
                    .frame(width: 100, alignment: .leading)
                Image(systemName: viewModel.resultFormat == "match" ? "checkmark.bubble.fill" : "ellipsis.bubble")
                TextField("Añade el formato para la fecha. Ejemplo: Y-m-d", text: $viewModel.formatDate)
                    .textFieldStyle(RoundTextFieldModifier())
                    .overlay(viewModel.resultFormat == "match" ?  RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("ok"), lineWidth: 2) : nil
                    )
            }
            HStack {
                Text(viewModel.resultDate)
                    .padding(15)
                    .font(.system(size: 36, weight: .bold))
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
