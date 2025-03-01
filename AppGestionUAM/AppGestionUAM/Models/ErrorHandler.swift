//
//  ErrorHandler.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//

import UIKit

extension UIViewController {
    func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                showAlert(title: "Error", message: "URL inválida.")
            case .encodingFailed:
                showAlert(title: "Error", message: "Error al codificar los datos.")
            case .decodingFailed:
                showAlert(title: "Error", message: "Error al procesar la respuesta del servidor.")
            case .validationFailed(let message):
                showAlert(title: "Validación Fallida", message: message)
            case .serverError(let message):
                showAlert(title: "Error del Servidor", message: message)
            case .userResgistered:
                showAlert(title: "Error al registrarse", message: "Usuario registrado")
            case .decodingError:
                showAlert(title: "Decoding error" , message: "Error al procesar los datos del servidor.")
            case .networkError:
                showAlert(title: "Error de conexion", message: "Error de red. Por favor, verifica tu conexión a Internet.")

            default:
                showAlert(title: "Error", message: "Ocurrió un error desconocido.")
            }
        } else {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }

    // Método auxiliar para mostrar alertas
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
