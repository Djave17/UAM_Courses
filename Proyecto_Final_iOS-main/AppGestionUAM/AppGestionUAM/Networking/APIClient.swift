//
//  APIClient.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL = URL(string: "https://uam-server.up.railway.app/api/v1")!
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("user/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Ejemplo de otro método: Obtener lista de cursos
    func fetchCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        
        let url = baseURL.appendingPathComponent("course_management")
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                completion(.success(courses))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
