//
//  DateFormatterView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/1/23.
//

import SwiftUI

struct DateFormatterView: View {
    @StateObject private var viewModel = DateFormatterViewModel()
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
        }
    }
}

struct DateFormatterView_Previews: PreviewProvider {
    static var previews: some View {
        JsonParserView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
