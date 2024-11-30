//
//  FavoritesManager.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

class FavoritesManager {
    private let favoritesKey = "favoriteCourses"
    
    func saveFavorite(course: CourseModel) {
        var favorites = fetchFavorites()
        favorites.append(course)
        saveFavorites(favorites)
    }
    
    func removeFavorite(courseID: String) {
        var favorites = fetchFavorites()
        favorites.removeAll { $0.id == courseID }
        saveFavorites(favorites)
    }
    
    func fetchFavorites() -> [CourseModel] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([CourseModel].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: [CourseModel]) {
        let data = try? JSONEncoder().encode(favorites)
        UserDefaults.standard.set(data, forKey: favoritesKey)
    }
}
