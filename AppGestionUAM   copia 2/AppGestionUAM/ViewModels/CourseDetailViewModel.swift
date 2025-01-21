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
    
    func loadImage(for url: String) async -> UIImage? {
        do {
            return try await apiClient.loadImage(from: url)
        } catch {
            onError?(error.localizedDescription)
            return nil
        }
    }
}
