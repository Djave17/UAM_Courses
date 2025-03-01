//
//  FavoriteCoursesViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 1/2/25.
//

import Foundation
@MainActor
class FavoriteCoursesViewModel {
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
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Fetch ONLY Favorite Courses
    /// Carga todos los cursos y posteriormente filtra únicamente los marcados como favoritos.
    func fetchFavoriteCourses(search: String? = nil) {
        // Recuperar el userId actual
        guard let userId = apiClient.getUserId() else {
            onError?("No hay un usuario logueado.")
            return
        }
        
        // Lanzar una Task asíncrona para traer cursos de la API
        Task {
            do {
                // Llamamos a la API para obtener la lista de cursos
                let fetchedCourses = try await apiClient.fetchCourses(search: search)
                
                // En el hilo principal, filtrar los cursos que son favoritos
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Obtenemos los IDs de cursos favoritos del usuario
                    let favoriteIDs = self.favoritesManager.fetchFavoriteIDs(userId: userId)
                    
                    // Filtramos solo los cursos que estén en `favoriteIDs`
                    let favoriteCourses = fetchedCourses.filter { favoriteIDs.contains($0.id) }
                    
                    // Actualizamos la propiedad isFavorite = true para todos los filtrados
                    self.courses = favoriteCourses.map { course in
                        var updated = course
                        updated.isFavorite = true
                        return updated
                    }
                }
            } catch let error as APIError {
                // Manejo de errores de la API
                DispatchQueue.main.async { [weak self] in
                    self?.onError?(error.localizedDescription)
                }
            } catch {
                // Otros errores genéricos
                DispatchQueue.main.async { [weak self] in
                    self?.onError?("Error desconocido: \(error.localizedDescription)")
                }
            }
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
