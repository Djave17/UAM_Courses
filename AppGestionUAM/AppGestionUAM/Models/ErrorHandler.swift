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
    
    /// Muestra una alerta con ícono opcional, botón de confirmación y botón de cancelación.
    /// - Parameters:
    ///   - title: Título principal de la alerta.
    ///   - message: Mensaje de la alerta.
    ///   - iconSystemName: Nombre del SF Symbol para el ícono (opcional). Por ejemplo: `"rectangle.portrait.and.arrow.right.fill"`.
    ///   - iconTintColor: Color que se aplicará al ícono.
    ///   - confirmTitle: Texto del botón de confirmación.
    ///   - confirmColor: Color del texto en el botón de confirmación.
    ///   - cancelTitle: Texto del botón de cancelación.
    ///   - cancelColor: Color del texto en el botón de cancelación.
    ///   - confirmHandler: Bloque a ejecutar cuando el usuario pulsa el botón de confirmación.
    func showCustomAlert(title: String,
                         message: String,
                         iconSystemName: String? = nil,
                         iconTintColor: UIColor = .systemBlue,
                         confirmTitle: String,
                         confirmColor: UIColor = .systemBlue,
                         cancelTitle: String,
                         cancelColor: UIColor = .systemGray,
                         confirmHandler: @escaping () -> Void) {
        
        // Se ajusta el espacio para que el ícono quepa al inicio
        let alert = UIAlertController(title: "\n\n\(title)", message: message, preferredStyle: .alert)
        
        if let iconSystemName = iconSystemName,
           let icon = UIImage(systemName: iconSystemName)?.withTintColor(iconTintColor, renderingMode: .alwaysOriginal) {
            
            let imageView = UIImageView(image: icon)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Agregar la vista del ícono a la alerta
            alert.view.addSubview(imageView)
            
            // Configurar restricciones para centrar el ícono
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15),
                imageView.widthAnchor.constraint(equalToConstant: 40),
                imageView.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        // Acción de Cancelar
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        cancelAction.setValue(cancelColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        // Acción de Confirmar
        let okAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler()
        }
        okAction.setValue(confirmColor, forKey: "titleTextColor")
        alert.addAction(okAction)
        
        // Presentar la alerta
        present(alert, animated: true, completion: nil)
    }
}
