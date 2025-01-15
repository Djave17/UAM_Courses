//
//  APIClient.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

//
//  APIClient.swift
//  AppGestionUAM
//
//  Updated by OpenAI Assistant
//

import Foundation
import UIKit

final class APIClient {
    static let shared = APIClient()
    let host = "https://uam-server.up.railway.app/api/v1"
    
    // MARK: - User Authentication
    
    func logIn(email: String, password: String) async throws -> LoginResponse? {
        // Validar que el endpoint sea correcto
        let endpoint = "\(host)/user/login"
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        do{
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let loginData: [String: String] = [
                "email": email,
                "password": password
            ]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {throw APIError.invalidResponse}
            
            
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            
            saveToken(loginResponse.token)
            
            return loginResponse
            
        } catch{
            return nil
        }
}
    
    
    
    //MARK: Register
    
    
    
    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let endpoint = "\(host)/user/register"
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = ["name": name, "email": email, "password": password]
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            throw APIError.encodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(AuthResponse.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        case 422:
            // Decodifica el ValidationError
            let validationError = try JSONDecoder().decode(ValidationError.self, from: data)
            throw APIError.validationFailed(validationError.msg)
        case 500:
            throw APIError.serverError("Error interno del servidor.")
        default:
            throw APIError.unknownError("Error desconocido. Código de estado: \(httpResponse.statusCode)")
        }
    }
    
    
    
    
    
    
    // MARK: - Course Management
    
    func fetchCourses(search: String? = nil) async throws -> [CourseModel] {
        // Construcción de la URL
        var urlString = "\(host)/course_management"
        if let search = search {
            urlString += "?search=\(search)"
        }

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        // Verificación del token de autenticación
        guard let token = getToken() else {
            throw APIError.unauthenticated
        }

        do {
            // Configuración de la solicitud
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            // Llamada a la API
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            // Manejo de códigos de estado HTTP
            switch httpResponse.statusCode {
            case 200:
                do {
                    // Decodificación de la respuesta
                    let coursesResponse = try JSONDecoder().decode(CourseResponse.self, from: data)
                    return coursesResponse.courses
                } catch {
                    throw APIError.decodingFailed
                }
            case 401:
                throw APIError.unauthorized("No autorizado. Por favor, verifique sus credenciales.")
            case 403:
                throw APIError.forbidden("Acceso denegado. No tiene permisos para acceder a este recurso.")
            case 404:
                throw APIError.notFound("Recurso no encontrado.")
            case 422:
                throw APIError.validationError("Error en la validación de los datos enviados.")
            case 500:
                throw APIError.serverError("Error interno del servidor.")
            default:
                throw APIError.unknownError("Error desconocido. Código de estado: \(httpResponse.statusCode)")
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError("Error de red: \(error.localizedDescription)")
        }
    }

    
    //MARK: Create courses
    func createCourse(course: CourseModel) async -> CourseModel? {
            guard let url = URL(string: "\(host)/course_management"),
                  let token = getToken() else { return nil }

            do {
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                urlRequest.httpBody = try JSONEncoder().encode(course)

                let (data, response) = try await URLSession.shared.data(for: urlRequest)

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Failed to create course, status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                    return nil
                }

                return try JSONDecoder().decode(CourseModel.self, from: data)
            } catch {
                print("Create Course Error: \(error)")
                return nil
            }
        }
    
    //MARK: Update Courses
    func updateCourse(courseID: String, updatedCourse: CourseModel) async -> CourseModel? {
        guard let url = URL(string: "\(host)/course_management/\(courseID)") else { return nil }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            urlRequest.httpBody = try JSONEncoder().encode(updatedCourse)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }
            
            return try JSONDecoder().decode(CourseModel.self, from: data)
        } catch {
            print("Update Course Error: \(error)")
            return nil
        }
    }
    
    //MARK: DeleteCourse
    func deleteCourse(courseID: String) async -> Bool {
        guard let url = URL(string: "\(host)/course_management/\(courseID)") else { return false }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return false }
            
            return true
        } catch {
            print("Delete Course Error: \(error)")
            return false
        }
    }
    
    // MARK: - Image Upload
    
    func uploadImage(image: UIImage) async throws -> String {
            guard let url = URL(string: "\(host)/upload_image") else {
                throw APIError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let imageData = image.jpegData(compressionQuality: 0.8)
            guard let data = imageData else { throw APIError.encodingFailed }
            
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            let (responseData, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                  let url = json["url"] as? String else {
                throw APIError.decodingFailed
            }
            
            return url
        }
    
    func loadImage(url: String) async -> UIImage? {
        guard let url = URL(string: url) else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard
                let urlResponse = response as? HTTPURLResponse,
                urlResponse.statusCode == 200
            else { return nil }
            
            let image = UIImage(data: data)
            
            return image
        } catch {
            return nil
        }
        
    }
    
    
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    private func getToken() -> String? {
        UserDefaults.standard.string(forKey: "token")
    }
    private func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    
}
