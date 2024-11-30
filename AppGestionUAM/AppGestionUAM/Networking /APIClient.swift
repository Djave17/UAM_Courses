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
    
    func logIn(email: String, password: String) async -> LoginResponse? {
        guard let url = URL(string: "\(host)/user/login") else { return nil }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let loginData = [
                "email": email,
                "password": password
            ]
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }
            
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        } catch {
            print("Login Error: \(error)")
            return nil
        }
    }
    //MARK: Register
    

    
    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let endpoint = "\(host)/api/v1/user/register"
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
            let validationError = try JSONDecoder().decode(ValidationError.self, from: data)
            throw APIError.validationFailed(validationError.msg)
        default:
            throw APIError.unknown
        }
    }



    

    
    
    // MARK: - Course Management
    
    func fetchCourses(search: String? = nil) async -> [CourseModel]? {
        var urlString = "\(host)/course_management"
        if let search = search {
            urlString += "?search=\(search)"
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }
            
            return try JSONDecoder().decode(CoursesResponse.self, from: data).courses
        } catch {
            print("Fetch Courses Error: \(error)")
            return nil
        }
    }
    
    //MARK: Create courses
    func createCourse(course: CourseModel) async -> CourseModel? {
        guard let url = URL(string: "\(host)/course_management") else { return nil }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            urlRequest.httpBody = try JSONEncoder().encode(course)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }
            
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
    
    func uploadImage(imageData: Data) async -> String? {
        guard let url = URL(string: "\(host)/upload_image") else { return nil }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            
            let boundary = UUID().uuidString
            let fieldName = "image"
            let fileName = "image.jpg"
            
            let body = NSMutableData()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = body as Data
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }
            
            guard let urlResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                  let imageUrl = urlResponse["url"] else { return nil }
            
            return imageUrl
        } catch {
            print("Upload Image Error: \(error)")
            return nil
        }
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
