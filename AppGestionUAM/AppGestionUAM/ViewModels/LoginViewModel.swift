import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    func login(completion: @escaping (Bool) -> Void) {
        // Validar que los campos no estén vacíos
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor, ingrese su correo y contraseña."
            completion(false)
            return
        }

        Task {
            do {
                // Intentar iniciar sesión
                if let response = try await APIClient.shared.logIn(email: email, password: password) {
                    DispatchQueue.main.async {
                        // Guardar el token en un lugar persistente
                        UserDefaults.standard.set(response.accessToken, forKey: "authToken")
                        
                        // Actualizar estado de autenticación
                        self.isAuthenticated = true
                        self.errorMessage = nil
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Credenciales inválidas."
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Ocurrió un error: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }
}
