//
//  ThemeSaver.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation

protocol IThemeStorageManager: AnyObject {
    func save(theme: String)
    func read() -> String?
}

final class ThemeStorageManager: IThemeStorageManager {
    
    private let serialQueue = DispatchQueue(label: "ru.wohagy.theme")
    
    private let localStorage: ILocalStorage
    
    private lazy var themeFileURL = localStorage.getWritingURL(forFile: "themeFile.txt")
    
    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage
    }
    
    func save(theme: String) {
        
        guard let fileURL = self.themeFileURL else { return }
        
        serialQueue.async {
            
            do {
                try theme.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                Logger.shared.message(error.localizedDescription)
            }
        }
        
    }
    
    func read() -> String? {
        
        guard let fileURL = self.themeFileURL else { return nil }
        
        do {
            let theme = try String(contentsOf: fileURL, encoding: .utf8)
            return theme
        } catch {
            Logger.shared.message(error.localizedDescription)
            return nil
        }
    }
}
