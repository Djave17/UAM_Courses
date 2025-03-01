//
//  LoginController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 20/11/24.
//

import Foundation

class LoginController {
    private let apiDataSource = APIClient()
    
    func login(email: String, password: String) async -> Result<LoginResponse, AuthError> {
        
        do {
            //Validar localmente antes de llamar a la API:
            guard !email.isEmpty, !password.isEmpty else {
                return .failure(.emptyFields)
            }
            
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
            guard isEmailValid else {
                return .failure(.invalidEmailFormat)
            }
            
            //  APIClient que podría arrojar errores propios:
            let loginResponse = try await apiDataSource.logIn(email: email, password: password)
            
            // Si la respuesta es nil, lo tratamos como error
            guard let unwrappedResponse = loginResponse else {
                return .failure(.invalidCredentials) // o el caso de AuthError que corresponda
            }
            
            return .success(unwrappedResponse)
            
            
        } catch let apiError as APIError {
            // 4) Mapea tu APIError a AuthError, si utilizas un error "APIError" en APIClient
            switch apiError {
            case .invalidCredentials:
                return .failure(.invalidCredentials)
            case .validationFailed(let message):
                return .failure(.serverError(message: message))
            default:
                return .failure(.unknown)
            }
            
        } catch {
            // 5) En caso de otro error no contemplado
            return .failure(.unknown)
        }
    }
}
