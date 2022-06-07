//
//  InternetImagePresenter.swift
//  iOS Chat
//
//  Created by Macbook on 24.04.2022.
//

import UIKit

protocol IImageCollectionPresenter: AnyObject {
    
    func viewDidLoad()
    func imageChosen(imageLink: String)
}

protocol ImageCollectionDelegate: AnyObject {
    func getInternetImage(imageLink: String)
}

final class ImageCollectionPresenter: IImageCollectionPresenter {
    init(view: IImageCollectionView, networkService: IRequestSender, delegate: ImageCollectionDelegate?) {
        self.view = view
        self.networkService = networkService
        self.delegate = delegate
    }
    
    private weak var view: IImageCollectionView?
    private weak var delegate: ImageCollectionDelegate?
    private let networkService: IRequestSender
    
    func viewDidLoad() {
        
        let request = RequestsFactory.ImageRequests.allImageConfig()
        networkService.send(requestConfig: request) { [weak self] result in
            switch result {
            case .success(let links):
                DispatchQueue.main.async {
                    self?.view?.imageData = links
                    self?.view?.showCollectionView()
                    self?.view?.collectionView.reloadData()
                }
            case .failure(let error):
                Logger.shared.message(error.localizedDescription)
            }
        }
    }
    
    func imageChosen(imageLink: String) {
        delegate?.getInternetImage(imageLink: imageLink)
    }
}
