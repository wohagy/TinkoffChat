//
//  ModuleBuilder.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import UIKit

protocol IAssemblyBuilder {
    func createChannelListModule(router: IRouter) -> UIViewController
    func createChannelModule(channelName: String, channelID: String, router: IRouter) -> UIViewController
    func createThemeModule(delegate: ThemesPickerDelegate?, router: IRouter) -> UIViewController
    func createProfileListModule(router: IRouter) -> UIViewController
    func createImageCollectionModule(delegate: ImageCollectionDelegate?) -> UIViewController
}

final class AssemblyBuilder: IAssemblyBuilder {
    
    private let localStorage = LocalStorage()
    private let coreDataService = CoreDataService(coreDataStack: CoreDataStack())
    private lazy var infoStorage = InformationStorageManager(localStorage: localStorage)
    private lazy var themeManager = ThemeManager(themeStorage: ThemeStorageManager(localStorage: localStorage))
    
    func createChannelListModule(router: IRouter) -> UIViewController {
        let view = ChannelsListViewController()
        let listenerService = ChannelsListener()
        let firestoreManager = FirestoreManager()
        let presenter = ChannelListPresenter(view: view,
                                             listenerService: listenerService,
                                             firestoreManager: firestoreManager,
                                             coreDataService: coreDataService,
                                             themeManager: themeManager,
                                             router: router)
        view.presenter = presenter
    
        return view
    }
    
    func createChannelModule(channelName: String, channelID: String, router: IRouter) -> UIViewController {
        let view = ChannelViewController()
        let listenerService = MessagesListener()
        let firestoreManager = FirestoreManager()
        let presenter = ChannelPresenter(view: view,
                                         listenerService: listenerService,
                                         firestoreManager: firestoreManager,
                                         coreDataService: coreDataService,
                                         themeManager: themeManager,
                                         infoStorage: infoStorage,
                                         router: router,
                                         channelID: channelID,
                                         channelName: channelName)
                                             
        view.presenter = presenter
    
        return view
    }
    
    func createThemeModule(delegate: ThemesPickerDelegate?, router: IRouter) -> UIViewController {
        let view = ThemesViewController()
        let presenter = ThemesPresenter(view: view,
                                        themeManager: themeManager,
                                        router: router,
                                        delegate: delegate)
        view.presenter = presenter
    
        return view
    }
    
    func createProfileListModule(router: IRouter) -> UIViewController {
        let view = ProfileViewController()
        let networkService = NetworkService()
        let presenter = ProfilePresenter(view: view,
                                         infoStorage: infoStorage,
                                         networkService: networkService,
                                         themeManager: themeManager,
                                         router: router)
        view.presenter = presenter
    
        return view
    }
    
    func createImageCollectionModule(delegate: ImageCollectionDelegate?) -> UIViewController {
        let view = ImageCollectionViewController()
        let networkService = NetworkService()
        let presenter = ImageCollectionPresenter(view: view, networkService: networkService, delegate: delegate)
        view.presenter = presenter
        
        return view
    }
}
