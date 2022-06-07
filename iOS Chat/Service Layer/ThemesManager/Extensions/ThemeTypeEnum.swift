//
//  TemesEnum.swift
//  iOS Chat
//
//  Created by Macbook on 17.03.2022.
//

import Foundation

enum ThemeType: String {
    case classic
    case day
    case night
    
    var colors: IThemeColors {
        switch self {
        case .classic:
            return ClassicThemeColors()
        case .day:
            return DayThemeColors()
        case .night:
            return NightThemeColors()
        }
    }
}
