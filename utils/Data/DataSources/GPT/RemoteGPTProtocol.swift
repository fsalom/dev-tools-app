//
//  RemoteGPTProtocol.swift
//  utils
//
//  Created by Fernando Salom Carratala on 15/12/23.
//

import Foundation

protocol GPTDataSourceProtocol {
    func send(this prompt: String, and context: [MessageDTO]) async throws -> MessageDTO?
}
