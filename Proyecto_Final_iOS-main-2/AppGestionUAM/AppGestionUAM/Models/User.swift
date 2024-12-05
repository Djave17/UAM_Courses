//
//  User.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//


import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    var authToken: String?
}
