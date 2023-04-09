//
//  RoundTextField.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/1/23.
//

import SwiftUI

struct RoundTextFieldModifier: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .padding(15)
            .font(.system(size: 12, weight: .regular))
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 2)
            )
    }
}
