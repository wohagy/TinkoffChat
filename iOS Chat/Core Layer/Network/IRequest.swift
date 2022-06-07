//
//  RequestProtocol.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}
