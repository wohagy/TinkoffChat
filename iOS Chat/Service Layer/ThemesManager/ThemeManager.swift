//
//  Colors.swift
//  iOS Chat
//
//  Created by Macbook on 16.03.2022.
//

import UIKit

protocol IThemeManager: AnyObject {
    
    init(themeStorage: IThemeStorageManager)
    
    var currentTheme: ThemeType { get }
    
    func changeTheme(for theme: ThemeType)
}

final class ThemeManager: IThemeManager {
    
    init(themeStorage: IThemeStorageManager) {
        self.themeStorage = themeStorage
        currentTheme = getCurrentTheme()
    }
    
    private let themeStorage: IThemeStorageManager
    
    private(set) var currentTheme: ThemeType = .classic {
        didSet {
            themeStorage.save(theme: currentTheme.rawValue)
        }
    }
    
    private func getCurrentTheme() -> ThemeType {
        if let savedTheme = themeStorage.read() {
            let themeType = ThemeType(rawValue: savedTheme)
            return themeType ?? .classic
        } else {
            return .classic
        }
    }
    
    func changeTheme(for theme: ThemeType) {
        currentTheme = theme
    }
    
}
