//
//  AuthError.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 28/2/25.
//


enum AuthError: Error {
    case invalidEmailFormat
    case emptyFields
    case passwordTooShort(minCharacters: Int)
    case serverError(message: String?)
    case invalidCredentials
    case unknown

    var localizedDescription: String {
        switch self {
        case .invalidEmailFormat:
            return "El correo electrónico no tiene el formato correcto."
        case .emptyFields:
            return "Todos los campos son obligatorios."
        case .passwordTooShort(let minCharacters):
            return "La contraseña debe tener al menos \(minCharacters) caracteres."
        case .serverError(let message):
            return message ?? "Ocurrió un error en el servidor."
        case .invalidCredentials:
            return "Usuario o contraseña incorrectos."
        case .unknown:
            return "Ha ocurrido un error desconocido."
        }
    }
}
