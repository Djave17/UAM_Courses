//
//  APIError.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 16/11/24.
//

import Foundation

enum APIError: Error, LocalizedError{
    case invalidCredentials
    case invalidResponse          // Respuesta no válida del servidor
    case invalidURL               // URL malformada
    case encodingFailed           // Error al codificar los datos
    case noData                   // Respuesta vacía del servidor
    case decodingFailed           // Error al decodificar la respuesta
    case validationFailed(String) // Error de validación con mensaje específico
    case serverError(String)
    case userResgistered
    case decodingError
    case networkError(String)
    case unknownError(String)
    case unauthenticated
    case unauthorized(String)
    case forbidden(String)
    case notFound(String)
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL proporcionada es inválida."
        case .invalidResponse:
            return "La respuesta del servidor es inválida."
        case .invalidCredentials:
            return "Credenciales incorrectas. Verifica tu correo y contraseña."
        case .unknownError(let message):
            return "Error desconocido: \(message)"
        case .encodingFailed:
            return "No se pudieron codificar los datos de la solicitud."
        case .noData:
            return "El servidor no devolvió ningún dato."
        case .decodingFailed:
            return "No se pudieron decodificar los datos de la respuesta."
        case .validationFailed(let message):
            return "Error de validación: \(message)"
        case .serverError(let message):
            return "Error del servidor: \(message)"
        case .userResgistered:
            return "El usuario ya está registrado. Por favor, inicia sesión."
        case .decodingError:
            return "Hubo un error al procesar los datos recibidos."
        case .networkError(let message):
            return "Error de red: \(message)"
        case .unauthenticated:
            return "El usuario no está autenticado."
        case .unauthorized(let message):
            return "No autorizado: \(message)"
        case .forbidden(let message):
            return "Acceso prohibido: \(message)"
        case .notFound(let message):
            return "No encontrado: \(message)"
        case .validationError(let message):
            return "Error de validación: \(message)"
        }
    }
}


