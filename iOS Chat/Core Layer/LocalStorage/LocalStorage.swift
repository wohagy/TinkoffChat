//
//  LocalStorage.swift
//  iOS Chat
//
//  Created by Macbook on 18.05.2022.
//

import Foundation

protocol ILocalStorage {
    func getWritingURL(forFile withName: String) -> URL?
}

final class LocalStorage: ILocalStorage {
    
    private let fileManager = FileManager.default
    
    func getWritingURL(forFile withName: String) -> URL? {
        let fileName = withName
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first else { return nil }
        let finalURL = url.appendingPathComponent(fileName)
        return finalURL
    }
}
