////
////  CourseListViewModel.swift
////  AppGestionUAM
////
////  Created by David Sanchez on 14/11/24.
////
//
import Foundation

final class CourseListViewModel {
    // MARK: - Properties
    private var apiClient: APIClient
    private(set) var courses: [CourseModel] = [] {
        didSet {
            onCoursesUpdated?()
        }
    }
    var onCoursesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Initializer
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Fetch Courses
    func fetchCourses(search: String? = nil) {
        Task {
            do {
                let fetchedCourses = try await apiClient.fetchCourses(search: search)
                DispatchQueue.main.async { [weak self] in
                    self?.courses = fetchedCourses
                }
            } catch let error as APIError {
                DispatchQueue.main.async { [weak self] in
                    self?.onError?(error.localizedDescription)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.onError?("Error desconocido: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Filter Courses (for search)
    func filterCourses(by keyword: String) -> [CourseModel] {
        return courses.filter {
            $0.name.localizedCaseInsensitiveContains(keyword) ||
            $0.description.localizedCaseInsensitiveContains(keyword)
        }
    }
}





