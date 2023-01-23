//
//  ContentView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/1/23.
//

import SwiftUI
import CoreData

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List(viewModel.menuOptions) { option in
                if let destination = option.destination as? JsonParserView {
                    NavigationLink(destination: destination) {
                        MenuListRowView(option: option)
                    }
                }
                if let destination = option.destination as? JsonEditorView {
                    NavigationLink(destination: destination) {
                        MenuListRowView(option: option)
                    }
                }
                if let destination = option.destination as? ExecuteView {
                    NavigationLink(destination: destination) {
                        MenuListRowView(option: option)
                    }
                }
            }
            .onAppear(perform: {
                viewModel.load()
            })
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
