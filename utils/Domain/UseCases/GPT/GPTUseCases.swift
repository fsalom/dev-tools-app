//
//  GPTUseCases.swift
//  utils
//
//  Created by Fernando Salom Carratala on 15/12/23.
//

import Foundation

class GPTUseCases: GPTUseCasesProtocol {
    var repository: GPTRepositoryProtocol

    init(repository: GPTRepositoryProtocol) {
        self.repository = repository
    }

    func send(this prompt: String, and context: [Message]) async throws -> Message? {
        try await repository.send(this: prompt, and: context)
    }
}
