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
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    TextField(text: $viewModel.message) {

                    }.textFieldStyle(RoundTextFieldModifier())
                    Button {
                        viewModel.speak()
                        // viewModel.execute()
                    } label: {
                        Image(systemName: "speaker.wave.3")
                    }.buttonStyle(GrowingButton())
                }
                HStack {
                    Button {
                        viewModel.executeXcode()
                        viewModel.ruby()
                    } label: {
                        Image(systemName: "speaker.wave.3")
                    }.buttonStyle(GrowingButton())
                }
                Spacer()
            }.padding(15)
            .navigationTitle("VoiceOver")
        }
    }
}

struct ExecuteView_Previews: PreviewProvider {
    static var previews: some View {
        ExecuteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
