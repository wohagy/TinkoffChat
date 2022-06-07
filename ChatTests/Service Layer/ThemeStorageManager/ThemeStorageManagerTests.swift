//
//  ThemeStorageManagerTests.swift
//  ChatTests
//
//  Created by Macbook on 19.05.2022.
//

import XCTest
@testable import iOS_Chat

class ThemeStorageManagerTests: XCTestCase {
    
    private let localStorageMock = LocalStorageMock()
    private lazy var themeStorageManager = build()
    
    func testGetWritingURLCalledFromRead() {
        
        _ = themeStorageManager.read()
        
        XCTAssertTrue(localStorageMock.invokedGetWritingURL)
        XCTAssertEqual(localStorageMock.invokedGetWritingURLCount, 1)
        XCTAssertEqual(localStorageMock.invokedGetWritingURLParameters?.withName, "themeFile.txt")
    }
    
    func testGetWritingURLCalledFromSave() {
        
        themeStorageManager.save(theme: "")
        
        XCTAssertTrue(localStorageMock.invokedGetWritingURL)
        XCTAssertEqual(localStorageMock.invokedGetWritingURLCount, 1)
        XCTAssertEqual(localStorageMock.invokedGetWritingURLParameters?.withName, "themeFile.txt")
    }
    
    private func build() -> ThemeStorageManager {
        return ThemeStorageManager(localStorage: localStorageMock)
    }

}
