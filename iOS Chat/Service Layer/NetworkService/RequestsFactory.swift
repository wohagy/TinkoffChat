//
//  RequestsFactory.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

struct RequestsFactory {
    struct ImageRequests {
        static func allImageConfig() -> RequestConfig<AllImagesParser> {
            return RequestConfig<AllImagesParser>(request: AllImageRequest(), parser: AllImagesParser())
        }
        
        static func loadImageConfig(imageLink: String) -> RequestConfig<LoadImageParser> {
            return RequestConfig<LoadImageParser>(request: LoadImageRequest(link: imageLink), parser: LoadImageParser())
        }
    }
}
