//
//  CourseDetailViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

class CourseDetailViewModel: ObservableObject {
    @Published var course: Course
    
    init(course: Course) {
        self.course = course
    }
    
    func markAsFavorite() {
        course.isFavorite.toggle()
        if course.isFavorite {
            FavoritesManager().saveFavorite(course: course)
        } else {
            FavoritesManager().removeFavorite(courseID: course.id)
        }
    }
}
