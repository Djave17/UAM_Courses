//
//  FavoritesManager.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//


import Foundation

class FavoritesManager {
    private func key(for userId: String) -> String {
        return "favoriteCoursesIDs_\(userId)"
    }
    
    // MARK: - Guardar un favorito (por ID)
    func saveFavorite(courseID: String, userId: String) {
        print("DEBUG: saveFavorite(\(courseID)) for userId \(userId)")
        var favorites = fetchFavoriteIDs(userId: userId)
        if !favorites.contains(courseID) {
            favorites.append(courseID)
            UserDefaults.standard.set(favorites, forKey: key(for: userId))
        }
    }
    
    // MARK: - Eliminar un favorito (por ID)
    func removeFavorite(courseID: String, userId: String) {
        print("DEBUG: removeFavorite(\(courseID)) for userId \(userId)")
        var favorites = fetchFavoriteIDs(userId: userId)
        favorites.removeAll { $0 == courseID }
        UserDefaults.standard.set(favorites, forKey: key(for: userId))
    }
    
    // MARK: - Obtener todos los IDs favoritos
    func fetchFavoriteIDs(userId: String) -> [String] {
        UserDefaults.standard.stringArray(forKey: key(for: userId)) ?? []
    }
}
