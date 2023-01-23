//
//  ExecuteView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/1/23.
//

import SwiftUI

struct ExecuteView: View {
    @StateObject private var viewModel = ExecuteViewModel()
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
                    Button {
                        viewModel.execute()
                    } label: {
                        Text("Enviar")
                    }.buttonStyle(GrowingButton())
                }
            }
        }
    }
}

struct ExecuteView_Previews: PreviewProvider {
    static var previews: some View {
        ExecuteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
