//
//  CourseDetailViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//


import Foundation
import UIKit

@MainActor
final class CourseDetailViewModel {
    private let apiClient: APIClient
    private(set) var course:CourseModel?
    var onError: ((String) -> Void)?
    var onDeleteSuccess: (() -> Void)?
    var onDeleteError: ((Error) -> Void)?
    var onUpdateSuccess: (() -> Void)?
    
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func fetchCourseDetails(name: String) async {
        do {
            let fetchedCourse = try await apiClient.fetchCourseById(name: name)
            print("Fetched Course: \(fetchedCourse)")
            self.course = fetchedCourse
        } catch {
            print("Error fetching course details: \(error.localizedDescription)")
            onError?(error.localizedDescription)
        }
    }
    // MARK: - Método para eliminar un curso
    /// - Parameter courseID: El ID del curso a eliminar
        func deleteCourse(withID courseID: String) {
            Task {
                do {
                    try await apiClient.deleteCourse(courseID: courseID)
                    DispatchQueue.main.async { [weak self] in
                        self?.onDeleteSuccess?()
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.onDeleteError?(error)
                    }
                }
            }
        }
    
    func loadImage(for url: String) async -> UIImage? {
        do {
            return try await apiClient.loadImage(url: url)
        } catch {
            onError?(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Update Course
    /// Actualiza la información de un curso en el servidor
    /// - Parameters:
    ///   - courseID: ID único del curso a actualizar
    ///   - updatedCourse: Objeto con los datos actualizados del curso
    ///   - image: Imagen opcional del curso
    func updateCourse(courseID: String, updatedCourse: CourseModel, image: UIImage?) async {
            do {
                var updatedCourseWithImage = updatedCourse
                if let image = image {
                    let imageURL = try await apiClient.uploadImage(image: image)
                    updatedCourseWithImage.imageUrl = imageURL
                }
                if let updated = try await apiClient.updateCourse(courseID: courseID, updatedCourse: updatedCourseWithImage) {
                    self.course = updated
                    DispatchQueue.main.async {
                        self.onUpdateSuccess?()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onError?("No se pudo actualizar el curso.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?("Error al actualizar el curso: \(error.localizedDescription)")
                }
            }
        }
}
