//
//  CourseResponse.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 10/1/25.
//
import Foundation
struct CourseResponse: Codable {
    let id: String
    let name: String
    let description: String
    let learningObjectives: String
    let schedule: String
    let prerequisites: String
    let materials: [String]
    let imageURL: String
}
