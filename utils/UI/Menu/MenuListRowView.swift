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
            VStack(alignment: .leading) {
                Text(option.name)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .redacted(reason: option.name.isEmpty ? .placeholder : [])
            }
        }
    }
}

struct MenuListRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MenuListRowView(option: .init(name: "JSON"))
        }
    }
}
