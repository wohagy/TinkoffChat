//
//  Router.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import UIKit

protocol IRouter {
    func initialViewController()
    func presentChannel(channelName: String, channelID: String)
    func presentThemes(delegate: ThemesPickerDelegate?)
    func presentProfile()
    func presentInternetImage(delegate: ImageCollectionDelegate?, previousVC: UIViewController?)
}

final class Router: IRouter {
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: IAssemblyBuilder
    
    init(navigationController: UINavigationController, assemblyBuilder: IAssemblyBuilder) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        let channelsListViewController = assemblyBuilder.createChannelListModule(router: self)
        navigationController.viewControllers = [channelsListViewController]
    }
    
    func presentChannel(channelName: String, channelID: String) {
        let channelViewController = assemblyBuilder.createChannelModule(channelName: channelName, channelID: channelID, router: self)
        navigationController.pushViewController(channelViewController, animated: true)
    }
    
    func presentThemes(delegate: ThemesPickerDelegate?) {
        let themesViewController = assemblyBuilder.createThemeModule(delegate: delegate, router: self)
        navigationController.pushViewController(themesViewController, animated: true)
    }
    
    func presentProfile() {
        let profileViewController = assemblyBuilder.createProfileListModule(router: self)
        guard let previousVC = navigationController.viewControllers.last else { return }
        
        let vc = UINavigationController(rootViewController: profileViewController)
        
        let transitionAnimator = FromCenterTransition()
    
        vc.transitioningDelegate = transitionAnimator
        vc.modalPresentationStyle = .overCurrentContext
       
        previousVC.present(vc, animated: true, completion: nil)
    }
    
    func presentInternetImage(delegate: ImageCollectionDelegate?, previousVC: UIViewController?) {
        let internetImageVC = assemblyBuilder.createImageCollectionModule(delegate: delegate) 
        previousVC?.present(internetImageVC, animated: true, completion: nil)
    }
}
