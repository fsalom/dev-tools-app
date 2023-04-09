//
//  Button.swift
//  utils
//
//  Created by Fernando Salom Carratala on 15/1/23.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    let padding: CGFloat
    let foreground: Color
    let cornerRadius: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .foregroundColor(foreground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
