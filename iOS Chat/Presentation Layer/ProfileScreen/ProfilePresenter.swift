//
//  ProfilePresenter.swift
//  iOS Chat
//
//  Created by Macbook on 20.04.2022.
//

import UIKit

protocol IProfilePresenter: AnyObject {
    
    func onViewDidLoad()
    func saveProfileInformation()
    func presentInternetImage(delegate: ImageCollectionDelegate?, previousVC: UIViewController?)
    func loadProfilePhoto(imageLink: String)
}

final class ProfilePresenter: IProfilePresenter {
    
    private weak var view: IProfileView?
    private let router: IRouter
    private let infoStorage: IInformationStorageManager
	private var networkService: IRequestSender?
    private let themeManager: IThemeManager
    
    init(view: IProfileView, infoStorage: IInformationStorageManager, networkService: IRequestSender, themeManager: IThemeManager, router: IRouter) {
         
        self.view = view
        self.infoStorage = infoStorage
        self.networkService = networkService
        self.themeManager = themeManager
        self.router = router
    }
    
    private func updateProfileView() {
        view?.profileView.savingPresentation(true)
        infoStorage.read(completion: { [weak self] model in
            if let model = model {
                self?.view?.profileView.updateProfileInformation(with: model)
            } else {
                self?.view?.showInfoAlert(info: "Can't load saved data")
            }
            self?.view?.profileView.savingPresentation(false)
        })
    }

    func onViewDidLoad() {
        view?.colors = themeManager.currentTheme.colors
        updateProfileView()
    }
    
    func saveProfileInformation() {
        
        let data: ProfileInformation
        do {
            guard let view = view else { return }
            data = try view.profileView.getEditedData()
        } catch {
            let err = error as? ProfileInformationError
            view?.showInfoAlert(info: err?.description ?? "Error")
            return
        }
        
        view?.profileView.savingPresentation(true)
        
        infoStorage.save(model: data, completion: { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.view?.profileView.updateProfileInformation(with: model)
                self?.view?.profileView.savingPresentation(false)
                self?.view?.showInfoAlert(info: "Data saved!")
            case .failure(let error):
                Logger.shared.message(error.localizedDescription)
                self?.view?.showErrorAlert { _ in
                    self?.saveProfileInformation()
                }
            }
        })
    }
    
    func presentInternetImage(delegate: ImageCollectionDelegate?, previousVC: UIViewController?) {
        router.presentInternetImage(delegate: delegate, previousVC: previousVC)
    }
    
    func loadProfilePhoto(imageLink: String) {
        let request = RequestsFactory.ImageRequests.loadImageConfig(imageLink: imageLink)
        networkService?.send(requestConfig: request) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.view?.profileView.setProfileImage(image: image) 
                }
            case .failure(let error):
                Logger.shared.message(error.localizedDescription)
            }
        }
    }
}
