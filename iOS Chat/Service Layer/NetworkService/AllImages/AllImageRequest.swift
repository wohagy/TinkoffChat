//
//  AllImageRequest.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

struct AllImageRequest: IRequest {
    
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "pixabay_api_key") as? String
    var urlRequest: URLRequest? {
        
        let components = getURLComponents()
        guard let url = components.url else { return nil }
        return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
    }
    
    private func getURLComponents() -> URLComponents {
        
        var components = URLComponents()

        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/api/"

        let queryItemApiKey = URLQueryItem(name: "key", value: apiKey)
        let queryItemQuery = URLQueryItem(name: "q", value: "profile")
        let queryItemImageType = URLQueryItem(name: "image_type", value: "photo")
        let queryItemPretty = URLQueryItem(name: "pretty", value: "true")
        let queryItemImageCount = URLQueryItem(name: "per_page", value: "150")

        components.queryItems = [queryItemApiKey, queryItemQuery, queryItemImageType, queryItemPretty, queryItemImageCount]
        
        return components
    }
}
