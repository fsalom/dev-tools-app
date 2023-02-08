//
//  MenuRowView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/1/23.
//

import SwiftUI

struct MenuListRowView: View {
    let option: Menu

    var body: some View {
        HStack {
            Image(systemName: option.icon)
            Text(option.name)
        }.padding(10)
    }
}

struct MenuListRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MenuListRowView(option: .init(name: "JSON", icon: "", destination: JsonEditorView()))
        }
    }
}
