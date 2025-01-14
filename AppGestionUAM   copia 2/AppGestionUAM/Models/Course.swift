//
//  Course.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

struct CourseModel: Codable, Hashable {
    let id: String?
    var name: String
    var description: String
    var learningObjectives: String
    var schedule: String
    var prerequisites: String
    var materials: [String]
    var imageUrl: String
    var isFavorite: Bool?

    init(id: String? = nil,
         name: String = "",
         description: String = "",
         learningObjectives: String = "",
         schedule: String = "",
         prerequisites: String = "",
         materials: [String] = [],
         imageURL: String = "",
         isFavorite: Bool? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.learningObjectives = learningObjectives
        self.schedule = schedule
        self.prerequisites = prerequisites
        self.materials = materials
        self.imageUrl = imageURL
        self.isFavorite = isFavorite
    }
}


