//
//  LocalStorageMock.swift
//  ChatTests
//
//  Created by Macbook on 18.05.2022.
//

import Foundation
@testable import iOS_Chat

final class LocalStorageMock: ILocalStorage {

    var invokedGetWritingURL = false
    var invokedGetWritingURLCount = 0
    var invokedGetWritingURLParameters: (withName: String, Void)?
    var invokedGetWritingURLParametersList = [(withName: String, Void)]()
    var stubbedGetWritingURLResult: URL? = URL(string: "TEST")

    func getWritingURL(forFile withName: String) -> URL? {
        invokedGetWritingURL = true
        invokedGetWritingURLCount += 1
        invokedGetWritingURLParameters = (withName, ())
        invokedGetWritingURLParametersList.append((withName, ()))
        return stubbedGetWritingURLResult
    }
}
