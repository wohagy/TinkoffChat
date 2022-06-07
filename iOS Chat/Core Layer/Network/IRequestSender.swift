//
//  RequestSenderProtocol.swift
//  iOS Chat
//
//  Created by Macbook on 25.04.2022.
//

import Foundation

protocol IRequestSender {
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, Error>) -> Void)
}
