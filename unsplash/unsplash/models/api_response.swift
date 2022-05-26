//
//  api_response.swift
//  unsplash
//
//  Created by macOS on 5/26/22.
//

import Foundation

struct ApiResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let small: String
}
