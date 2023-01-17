//
//  Header.swift
//  utils
//
//  Created by Fernando Salom Carratala on 17/1/23.
//

import Foundation


struct Header: Identifiable, Equatable {
    var id = UUID()
    var key: String
    var value: String

    static func ==(lhs: Header, rhs: Header) -> Bool {
        return lhs.id == rhs.id
    }
}
