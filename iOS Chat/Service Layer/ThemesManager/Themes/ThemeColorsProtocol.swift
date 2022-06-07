//
//  ThemeColorsProtocol.swift
//  iOS Chat
//
//  Created by Macbook on 28.03.2022.
//

import UIKit

protocol IThemeColors {
    
    var dateLabelColor: UIColor { get }
    var backgroundGray: UIColor { get }
    var backgroundWhite: UIColor { get }
    var channelScreenBackground: UIColor { get }
    var onlineBackground: UIColor { get }
    var inComingMessage: UIColor { get }
    var outComingMessage: UIColor { get }
    var buttonBlue: UIColor { get }
}
