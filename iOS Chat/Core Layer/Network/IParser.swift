//
//  ParserProtocol.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
