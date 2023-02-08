//
//  FirebaseTesterView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 26/1/23.
//

import SwiftUI

struct FirebaseTesterView: View {
    @State private var openFile = false
    var body: some View {
        Form {
            //image 1
            Button {
                self.openFile.toggle()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
        .navigationTitle("File Importer")

        //file importer
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.json]) { (res) in
            do{
                let fileUrl = try res.get()
                print(fileUrl)
                guard fileUrl.startAccessingSecurityScopedResource() else { return }
            } catch{

                print ("error reading")
                print (error.localizedDescription)
            }
        }
    }
}
