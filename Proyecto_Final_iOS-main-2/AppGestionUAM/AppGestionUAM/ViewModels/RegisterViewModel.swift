//
//  RegisterViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//
import UIKit

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegistered = false
    @Published var errorMessage: String?

    func registerUser() async {
        do {
            let authResponse = try await APIClient.shared.register(name: name, email: email, password: password)
            DispatchQueue.main.async {
                self.isRegistered = true
                self.errorMessage = nil
                print("Registro exitoso. Token: \(authResponse.token)")
                print("hola")
            }
        } catch let apiError as APIError {
            DispatchQueue.main.async {
                self.isRegistered = false
                self.errorMessage = apiError.localizedDescription
            }
        } catch {
            DispatchQueue.main.async {
                self.isRegistered = false
                self.errorMessage = "Error inesperado: \(error.localizedDescription)"
            }
        }
    }
}
