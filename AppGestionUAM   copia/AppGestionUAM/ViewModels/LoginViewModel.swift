//import Foundation
//
//class LoginViewModel: ObservableObject {
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var isAuthenticated = false
//    @Published var errorMessage: String?
//
//    func login(completion: @escaping (Bool) -> Void) {
//        // Validar que los campos no estén vacíos
//        guard !email.isEmpty, !password.isEmpty else {
//            errorMessage = "Por favor, ingrese su correo y contraseña."
//            completion(false)
//            return
//        }
//
//        Task {
//            do {
//                // Llamar al APIClient para iniciar sesión
//                let response = try await APIClient.shared.logIn(email: email, password: password)
//                DispatchQueue.main.async {
//                    // Guardar el token en un lugar persistente
//                    UserDefaults.standard.set(response.token, forKey: "token")
//                    
//                    // Actualizar estado de autenticación
//                    self.isAuthenticated = false
//                    self.errorMessage = nil
//                    completion(true)
//                }
//            } catch let apiError as APIError {
//                DispatchQueue.main.async {
//                    // Manejar errores específicos del API
//                    switch apiError {
//                    case .validationFailed(let message):
//                        self.errorMessage = "Validación fallida: \(message)"
//                    case .serverError(let message):
//                        self.errorMessage = "Error del servidor: \(message)"
//                    case .decodingFailed:
//                        self.errorMessage = "Error al procesar la respuesta del servidor."
//                    case .noData:
//                        self.errorMessage = "No se recibió respuesta del servidor. Verifica tu conexión."
//                    default:
//                        self.errorMessage = "Ocurrió un error inesperado. Intenta más tarde."
//                    }
//                    completion(false)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    // Manejar otros errores
//                    self.errorMessage = "Ocurrió un error: \(error.localizedDescription)"
//                    completion(false)
//                }
//            }
//        }
//    }
//}
