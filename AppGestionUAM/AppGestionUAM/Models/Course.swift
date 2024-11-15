//
//  Course.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

struct Course: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let learningObjectives: String
    let schedule: String
    let prerequisites: String
    let materials: [String]
    let imageUrl: String
    var isFavorite: Bool = false
}
