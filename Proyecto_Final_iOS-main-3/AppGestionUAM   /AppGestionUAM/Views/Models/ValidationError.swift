//
//  ValidationError.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//

struct ValidationError: Codable {
    let loc: [String]
    let msg: String
    let type: String
}

struct items: Codable {
    let loc: [String]
    let msg: String
    let type: String
}

