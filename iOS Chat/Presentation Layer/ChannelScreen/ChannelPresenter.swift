//
//  ChannelPresenter.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation
import FirebaseFirestore

protocol IChannelPresenter: AnyObject {
    
    func onViewDidLoad()
    func sendMessage(with content: String)
    func presentInternetImage(delegate: ImageCollectionDelegate?, previousVC: UIViewController?)
}

final class ChannelPresenter: IChannelPresenter {
    
    private let channelID: String
    private let channelName: String
    
    private let userID = UIDevice.current.identifierForVendor?.uuidString
    private var userName: String?
    
    private weak var view: IChannelView?
    private let listenerService: IMessagesListener
    private let firestoreManager: IFirestoreManager
    private var messagesListener: ListenerRegistration?
    private let coreDataService: ICoreDataService
    private let infoStorage: IInformationStorageManager
    private let themeManager: IThemeManager
    private let router: IRouter
    
    init(view: IChannelView,
         listenerService: IMessagesListener,
         firestoreManager: IFirestoreManager,
         coreDataService: ICoreDataService,
         themeManager: IThemeManager,
         infoStorage: IInformationStorageManager,
         router: IRouter,
         channelID: String,
         channelName: String) {
        
        self.view = view
        self.listenerService = listenerService
        self.firestoreManager = firestoreManager
        self.coreDataService = coreDataService
        self.themeManager = themeManager
        self.infoStorage = infoStorage
        self.router = router
        self.channelID = channelID
        self.channelName = channelName
    }
    
    deinit {
        messagesListener?.remove()
    }
    
    private func addMessagesListener() {
        messagesListener = listenerService.messagesObserve(channelID: channelID, completion: { [weak self] (result) in
            switch result {
            case .success(let messageResult):
                switch messageResult.resultState {
                case .added:
                    guard let id = self?.channelID else { return }
                    self?.coreDataService.saveMessage(message: messageResult.message, channelId: id)
                case .modified, .removed:
                    break
                }
            case .failure(let error):
                Logger.shared.message(error.localizedDescription)
            }
        })
    }
    
    private func getUserName() {
        infoStorage.read { [weak self] profile in
            if let savedName = profile?.name {
                self?.userName = savedName
            } else {
                self?.view?.showInfoAlert(info: "You need to enter your information to profile")
            }
        }
    }
    
    func onViewDidLoad() {
        addMessagesListener()
        getUserName()
        view?.coreDataService = coreDataService
        view?.setupFetchedResultsController(with: channelID)
        view?.colors = themeManager.currentTheme.colors
        view?.userID = userID
        view?.setNavigationItemTitle(title: channelName)
    }
    
    func sendMessage(with content: String) {
        
        guard let senderName = userName,
              let senderID = userID else { return }

        let message = MessageModel(content: content,
                                   created: Date(),
                                   senderId: senderID,
                                   senderName: senderName)
        
        firestoreManager.messageSave(channelID: channelID, message: message)
    }
    
    func presentInternetImage(delegate: ImageCollectionDelegate?, previousVC: UIViewController?) {
        router.presentInternetImage(delegate: delegate, previousVC: previousVC)
    }
}
