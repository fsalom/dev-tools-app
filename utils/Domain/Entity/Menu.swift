//
//  Menu.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/1/23.
//

import Foundation
import SwiftUI

struct Menu: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var destination: any View
}
