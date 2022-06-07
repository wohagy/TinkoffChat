//
//  LoadImageParser.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import UIKit

final class LoadImageParser: IParser {

    typealias Model = UIImage
    
    func parse(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
