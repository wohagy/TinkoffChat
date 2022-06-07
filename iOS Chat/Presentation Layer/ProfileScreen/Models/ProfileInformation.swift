//
//  ProfileInformation.swift
//  iOS Chat
//
//  Created by Macbook on 23.03.2022.
//

import UIKit

struct ProfileInformation {
    let name: String
    let bio: String
    let location: String
    let image: UIImage?
}

struct ProfileInformationCodable: Codable {
    let name: String
    let bio: String
    let location: String
}
