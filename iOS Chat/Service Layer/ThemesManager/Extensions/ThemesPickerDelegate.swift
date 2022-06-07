//
//  ThemeChangerProtocol.swift
//  iOS Chat
//
//  Created by Macbook on 17.03.2022.
//

import Foundation

protocol ThemesPickerDelegate: AnyObject {
    func changeTheme(to theme: ThemeType)
}
