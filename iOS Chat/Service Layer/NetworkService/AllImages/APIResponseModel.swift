//
//  APIResponseModel.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

// MARK: - APIResponseModel

struct APIResponseModel: Codable {
    let total, totalHits: Int
    let hits: [Hit]
}

// MARK: - Hit

struct Hit: Codable {
    let previewURL: String
    let webformatURL: String
}
