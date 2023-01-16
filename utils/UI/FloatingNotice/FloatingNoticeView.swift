//
//  ModelView.swift
//  utils
//
//  Created by Fernando Salom Carratala on 16/1/23.
//

import SwiftUI

struct FloatingNotice: View {
    @Binding var showingNotice: Bool
    @State var alpha: Double = 0
    var body: some View {
        VStack (alignment: .center, spacing: 8) {
            Image(systemName: "doc.on.doc.fill")
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .regular))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            Text("URL copiada")
                .foregroundColor(.white)
                .font(.callout)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .frame(width: 200)
        .background(Color.gray.opacity(0.75))
        .cornerRadius(20)
        .transition(.scale)
        .opacity(alpha)
        .onAppear(perform: {
            withAnimation {
                alpha = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.showingNotice = false
            })
        })
    }
}
