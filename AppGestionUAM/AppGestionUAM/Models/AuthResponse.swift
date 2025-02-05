//
//  AuthResponse.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//
// Modelo para la respuesta de autenticación
import Foundation

struct AuthResponse: Decodable {
    let token: String
    let user: User
}

