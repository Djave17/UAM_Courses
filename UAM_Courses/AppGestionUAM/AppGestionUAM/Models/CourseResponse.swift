//
//  CourseResponse.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 10/1/25.
//
import Foundation
struct CourseResponse: Decodable, Hashable{
//    let courses: [CourseModel]
    let data: [CourseModel]
    
    //Coding Key
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

