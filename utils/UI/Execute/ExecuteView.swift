//
//  ExecuteView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/1/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExecuteView: View {
    @StateObject private var viewModel = ExecuteViewModel()
    @State private var text: String = ""
    @State private var fileImporterIsPresented: Bool = false
    @State private var path: String = ""
    @State private var errorMessage: String = ""
    @State var presentingModal = false
    private let xcodeproj: UTType
    @State private var width: CGFloat = 0
    @FocusState private var focusedField: Field?
    @Environment(\.openURL) private  var openURL
    @Environment(\.managedObjectContext) private var viewContext

    private enum Field: Int, CaseIterable {
        case url
    }

    init() {
        guard let type = UTType(tag: "xcodeproj", tagClass: .filenameExtension, conformingTo: .compositeContent) else { fatalError() }
        xcodeproj = type
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
                }.padding(15)
                HStack {
                    Button {
                        viewModel.executeXcode()
                        viewModel.ruby()
                    } label: {
                        Image(systemName: "scroll")
                    }.buttonStyle(GrowingButton())
                }.padding(15)
                HStack {
                    Button {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.allowedContentTypes = [xcodeproj]
                        panel.canChooseDirectories = false
                        if panel.runModal() == .OK {
                            path = panel.urls.first?.absoluteString ?? ""
                        }
                    } label: {
                        Label("Añadir proyecto", systemImage: "folder.badge.plus")
                    }.buttonStyle(GrowingButton())
                    Text(path)
                }.padding(15)
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
