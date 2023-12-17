//
//  GPTRepositoryProtocol.swift
//  utils
//
//  Created by Fernando Salom Carratala on 15/12/23.
//

import Foundation

protocol GPTRepositoryProtocol {
    func send(this prompt: String, and context: [Message]) async throws -> Message?
}
