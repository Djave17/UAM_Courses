//
//  ErrorHandler.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//

import UIKit

private var isAlertPresented: Bool = false

extension UIViewController {
    func handleError(_ error: Error) {
        guard !isAlertPresented else { return } // Evitar múltiples alertas
        isAlertPresented = true

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
            default:
                showAlert(title: "Error", message: "Ocurrió un error desconocido.")
            }
        } else {
            showAlert(title: "Error", message: error.localizedDescription)
        }

        // Asegúrate de permitir futuras alertas después de cerrar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAlertPresented = false
        }
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
