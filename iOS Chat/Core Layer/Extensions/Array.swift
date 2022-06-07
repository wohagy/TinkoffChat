//
//  Array.swift
//  iOS Chat
//
//  Created by Macbook on 13.03.2022.
//

import Foundation

extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
