//
//  CreateCourseViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 10/1/25.
//

import Foundation
import UIKit

@MainActor
class CreateCourseViewModel {
    // MARK: - Properties
    var name: String = ""
    var description: String = ""
    var learningObjectives: String = ""
    var schedule: String = ""
    var prerequisites: String = ""
    var materials: [String] = []
    var selectedImage: UIImage?

    var onError: ((String) -> Void)?
    var onSuccess: (() -> Void)?

    // MARK: - Methods
    func validateFields() -> Bool {
        guard !name.isEmpty, !description.isEmpty, !learningObjectives.isEmpty, !schedule.isEmpty, !prerequisites.isEmpty, !materials.isEmpty else {
            onError?("Todos los campos son obligatorios.")
            return false
        }
        return true
    }

    func createCourse() {
        guard validateFields() else { return }

        Task {
            do {
                var imageUrl: String = ""
                if let image = selectedImage {
                    imageUrl = try await APIClient.shared.uploadImage(image: image)
                }

                let course = CourseModel(
                    name: name,
                    description: description,
                    learningObjectives: learningObjectives,
                    schedule: schedule,
                    prerequisites: prerequisites,
                    materials: materials,
                    imageUrl: imageUrl
                )


                try await APIClient.shared.createCourse(course: course)
                onSuccess?()
            } catch let apiError as APIError {
                onError?(apiError.localizedDescription)
            } catch {
                onError?("Ocurrió un error desconocido.")
            }
        }
    }
}
