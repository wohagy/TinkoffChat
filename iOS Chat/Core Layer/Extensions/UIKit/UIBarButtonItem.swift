//
//  UIColor + UIBarButtonItem.swift
//  iOS Chat
//
//  Created by Macbook on 07.03.2022.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String?,
                     target: AnyObject?,
                     action: Selector?) {
        self.init()
        self.title = title
        self.target = target
        self.action = action
        self.tintColor = ThemeManager.shared.currentTheme.colors.buttonBlue
        self.style = .done
    }
}
