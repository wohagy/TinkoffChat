//
//  ProfileInformationError.swift
//  iOS Chat
//
//  Created by Macbook on 18.04.2022.
//

import Foundation

enum ProfileInformationError: Error {
    case emptyName
    case emptyBio
    case emptyLocation
    case nothingChanged
    
    var description: String {
        switch self {
        case .emptyName:
            return "Invalid name"
        case .emptyBio:
            return "Invalid bio"
        case .emptyLocation:
            return "Invalid location"
        case .nothingChanged:
            return "Information not changed"
        }
    }
}
