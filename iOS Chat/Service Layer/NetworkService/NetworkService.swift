//
//  NetworkService.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

final class NetworkService: IRequestSender {
    
    private let session = URLSession.shared
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(NetworkError.badURL))
            return
        }
        let task = session.dataTask(with: urlRequest) { (data: Data?, _, error: Error?) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data,
                  let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.failure(NetworkError.badData))
                    return
                    }
            completionHandler(.success(parsedModel))
        }
        task.resume()
    }}
