//
//  CourseListController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 16/11/24.
//

import UIKit

final class CourseListController {
    private let apiClient = APIClient.shared
    
//    func fetchCourses(query: String = "") async -> [CourseModel]? {
//        await apiClient.fetchCourses(search: query)
//    }
    
    func loadImage(url: String) async -> UIImage? {
        guard let imageUrl = URL(string: url) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}
