//
//  AllImagesParser.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

final class AllImagesParser: IParser {
    
    typealias Model = [String]
    
    func parse(data: Data) -> [String]? {
        
        do {
            let result = try JSONDecoder().decode(APIResponseModel.self, from: data)
            let links = result.hits.map { $0.webformatURL }
            return links
            
        } catch {
            return nil
        }
    }
}
