//
//  LoadImageRequest.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

struct LoadImageRequest: IRequest {
    var link: String
    var urlRequest: URLRequest? {
        guard let url = URL(string: link) else { return nil }
        return URLRequest(url: url)
    }
}
