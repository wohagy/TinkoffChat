//
//  ThemesPresenter.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation

protocol IThemesPresenter: AnyObject {
    
    func onViewDidLoad()
    func changeTheme(theme: ThemeType)
}

final class ThemesPresenter: IThemesPresenter {
       
    private weak var view: IThemesView?
    private weak var delegate: ThemesPickerDelegate?
    private let router: IRouter
    private let themeManager: IThemeManager
    
    init(view: IThemesView, themeManager: IThemeManager, router: IRouter, delegate: ThemesPickerDelegate?) {
        self.view = view
        self.themeManager = themeManager
        self.router = router
        self.delegate = delegate
    }
    
    func onViewDidLoad() {
        view?.colors = themeManager.currentTheme.colors
        
        let currentTheme = themeManager.currentTheme
        view?.activateCurrentTheme(currentTheme: currentTheme)
    }
    
    func changeTheme(theme: ThemeType) {
        themeManager.changeTheme(for: theme)
        delegate?.changeTheme(to: theme)
    }
}
