//
//  LoginViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    
    func login(completion: @escaping (Error?) -> Void) {
        APIClient.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(var user):
                    // Guardar token y actualizar el estado de autenticación
                    user.authToken = user.authToken
                    self.isAuthenticated = true
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}
