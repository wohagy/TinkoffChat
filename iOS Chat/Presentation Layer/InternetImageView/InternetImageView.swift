//
//  InternetImageView.swift
//  iOS Chat
//
//  Created by Macbook on 16.05.2022.
//

import UIKit

final class InternetImageView: UIImageView {
    
    private let networkService = NetworkService()
    
    func setImageFromInternet(imageLink: String) {
        
        let request = RequestsFactory.ImageRequests.loadImageConfig(imageLink: imageLink)
        
        networkService.send(requestConfig: request) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            case .failure(let error):
                Logger.shared.message(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "errorImage")
                }
            }
        }
    }
}
