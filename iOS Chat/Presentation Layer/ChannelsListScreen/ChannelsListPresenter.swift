//
//  ChannelsListPresenter.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation
import FirebaseFirestore

protocol IChannelListPresenter: AnyObject {
 
    func onViewDidLoad()
    func addNewChannel(with channelName: String)
    func deleteChannel(with channelID: String)
    func presentChannel(channelName: String, channelID: String)
    func presentThemes(delegate: ThemesPickerDelegate?)
    func presentProfile()
}

final class ChannelListPresenter: IChannelListPresenter {

    private weak var view: IChannelsListView?
    private let listenerService: IChannelsListener
    private let firestoreManager: IFirestoreManager
    private let router: IRouter
    private let coreDataService: ICoreDataService
    private var channelsListener: ListenerRegistration?
    private let themeManager: IThemeManager
    
    init(view: IChannelsListView,
         listenerService: IChannelsListener,
         firestoreManager: IFirestoreManager,
         coreDataService: ICoreDataService,
         themeManager: IThemeManager,
         router: IRouter) {
        
        self.view = view
        self.listenerService = listenerService
        self.firestoreManager = firestoreManager
        self.coreDataService = coreDataService
        self.themeManager = themeManager
        self.router = router
    }
     
    deinit {
        channelsListener?.remove()
    }
    
    private func addChannelListener() {
        channelsListener = listenerService.channelsObserve(completion: { [weak self] result in
            switch result {
            case .success(let channelResult):
                switch channelResult.resultState {
                case .added:
                    self?.coreDataService.saveChannel(channel: channelResult.channel)
                case .modified:
                    self?.coreDataService.updateChannel(channel: channelResult.channel)
                case .removed:
                    self?.coreDataService.removeChannel(channel: channelResult.channel)
                }
            case .failure(let error):
                Logger.shared.message(error.localizedDescription)
            }
        })
    }
    
    func onViewDidLoad() {
        addChannelListener()
        view?.coreDataService = coreDataService
        view?.setupFetchedResultsController()
        view?.colors = themeManager.currentTheme.colors
    }
    
    func addNewChannel(with channelName: String) {
        firestoreManager.channelSave(channelName: channelName)
    }
    
    func deleteChannel(with channelID: String) {
        firestoreManager.channelDelete(channelID: channelID)
    }
    
    func presentChannel(channelName: String, channelID: String) {
        router.presentChannel(channelName: channelName, channelID: channelID)
    }
    
    func presentThemes(delegate: ThemesPickerDelegate?) {
        router.presentThemes(delegate: delegate)
    }
    
    func presentProfile() {
        router.presentProfile()
    }
}
