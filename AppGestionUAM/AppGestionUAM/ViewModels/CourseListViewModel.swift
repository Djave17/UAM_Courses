////
////  CourseListViewModel.swift
////  AppGestionUAM
////
////  Created by David Sanchez on 14/11/24.
////
//
import Foundation
@MainActor
final class CourseListViewModel {
    // MARK: - Properties
    private var apiClient: APIClient
    private let favoritesManager = FavoritesManager()
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
    func fetchCourses(search: String? = "") {
        let userId = apiClient.getUserId()
        Task {
            do {
                let fetchedCourses = try await apiClient.fetchCourses(search: search)
                
                // Notar que ya estamos en un Task, pero por seguridad hacemos Dispatch a main
                DispatchQueue.main.async { [weak self] in
                    guard let self = self,
                          let userId = apiClient.getUserId() else { return }
                    
                    let favoriteIDs = self.favoritesManager.fetchFavoriteIDs(userId: userId)
                    
                    // Asignar isFavorite
                    self.courses = fetchedCourses.map { course in
                        var updated = course
                        updated.isFavorite = favoriteIDs.contains(course.id)
                        return updated
                    }
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
    // MARK: - Cambiar estado de favorito
    func toggleFavorite(for course: CourseModel) {
        // Si ya está en favoritos, lo quitamos
        let userId = apiClient.getUserId()
        print("DEBUG - All UserDefaults: \(UserDefaults.standard.dictionaryRepresentation())")
        print("DEBUG: userId = \(String(describing: userId))")
        
        guard let userId = userId else {
            print("DEBUG: userId es nil: no se guarda favorito.")
            return
        }
        
        if course.isFavorite == true {
            favoritesManager.saveFavorite(courseID: course.id, userId: userId)
        } else {
            favoritesManager.removeFavorite(courseID: course.id, userId: userId)
        }
        
        // Actualizamos isFavorite localmente
        if let index = courses.firstIndex(where: { $0.id == course.id }) {
            courses[index].isFavorite = !(courses[index].isFavorite ?? false)
        }
        
        // Notificar a la vista
        onCoursesUpdated?()
    }
    
}





