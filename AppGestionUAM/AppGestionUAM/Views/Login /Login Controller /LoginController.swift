//
//  LoginController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 20/11/24.
//

import Foundation


class LoginController {
    private let apiDataSource = APIClient()

    func login(email: String, password: String) async -> LoginResponse?{
        do {
            return try await apiDataSource.logIn(email: email, password: password)
        } catch {
            print("Error en el controller.") 
            return nil
        }
    }
}
