//
//  APIError.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 16/11/24.
//

enum APIError: Error {
    case invalidURL
    case encodingFailed
    case decodingFailed
    case validationFailed(String)
    case serverError(String)
    case unknown
    case invalidResponse

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL inválida."
        case .encodingFailed:
            return "Error al codificar los datos."
        case .decodingFailed:
            return "Error al procesar la respuesta del servidor."
        case .validationFailed(let message):
            return "Validación Fallida: \(message)"
        case .serverError(let message):
            return "Error del Servidor: \(message)"
        case .unknown:
            return "Ocurrió un error desconocido."
        case .invalidResponse:
            return "Response invalid"
        }
    }
}
