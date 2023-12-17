//
//  GPTRepository.swift
//  utils
//
//  Created by Fernando Salom Carratala on 15/12/23.
//

import Foundation

class GPTRepository: GPTRepositoryProtocol {
    var datasource: GPTDataSourceProtocol

    init(datasource: GPTDataSourceProtocol) {
        self.datasource = datasource
    }

    func send(this prompt: String, and context: [Message]) async throws -> Message? {
        return try await datasource.send(this: prompt, and: context.map({$0.toDTO()}))?.toDomain()
    }
}

fileprivate extension MessageDTO {
    func toDomain() -> Message {
        Message(role: self.role, content: self.content)
    }
}

fileprivate extension Message {
    func toDTO() -> MessageDTO {
        MessageDTO(role: self.role, content: self.content ?? "")
    }
}
