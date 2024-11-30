//
//  AuthResponse.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//
// Modelo para la respuesta de autenticación
struct AuthResponse: Codable {
    let token: String
    let user: User
}
