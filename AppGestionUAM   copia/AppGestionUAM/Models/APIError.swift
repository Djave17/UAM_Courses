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
    case networkError
    case unknownError
    
    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "La URL proporcionada es inválida."
            case .invalidResponse:
                return "La respuesta del servidor es inválida."
            case .invalidCredentials:
                return "Credenciales incorrectas. Verifica tu correo y contraseña."
            case .unknownError:
                return "Ocurrió un error desconocido."
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
            case .networkError:
                return "Hubo un problema con la red. Verifica tu conexión a Internet."
        }
    }
}


