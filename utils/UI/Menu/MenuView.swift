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
                NavigationLink(destination: JsonParserView()) {
                    MenuListRowView(option: option)
                }
            }
            .onAppear(perform: {
                viewModel.load()
            }).navigationViewStyle(.stack)
            Text("Select an item")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
