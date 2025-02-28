//
//  ImageRespose.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 18/1/25.
//
import Foundation

struct ImageResponse: Decodable {
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case image = "image"
    }
}

