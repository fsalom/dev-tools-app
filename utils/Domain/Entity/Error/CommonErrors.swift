//
//  CommonErrors.swift
//  utils
//
//  Created by Fernando Salom Carratala on 22/1/23.
//

import Foundation

enum CommonError: Error {
    case parsingJSON
    case parsingURL
    case invalidURL
    case networkFailed
    case xcodeprojectNotSelected

    var localizedDescription: String {
        switch self {
        case .parsingURL:
            return "La url parece no devolver un JSON correcto"
        case.parsingJSON:
            return "Se ha producido un error parseando el JSON"
        case .invalidURL:
            return "La URL no es válida"
        case .networkFailed:
            return "Se ha producido un error accediendo al endpoint"
        case .xcodeprojectNotSelected:
            return "Debes seleccionar el proyecto destino"
        }
    }
}
