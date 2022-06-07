//
//  InformationStorageManagerTests.swift
//  ChatTests
//
//  Created by Macbook on 18.05.2022.
//

import XCTest
@testable import iOS_Chat

class InformationStorageManagerTests: XCTestCase {
    
    private let localStorageMock = LocalStorageMock()
    private lazy var informationStorageManager = build()
    private let profileInformationMock = ProfileInformation(name: "", bio: "", location: "", image: nil)
    
    func testGetWritingURLCalledFromRead() {
        
        informationStorageManager.read { _ in }
        
        XCTAssertTrue(localStorageMock.invokedGetWritingURL)
        XCTAssertEqual(localStorageMock.invokedGetWritingURLCount, 2)
        XCTAssertTrue(localStorageMock.invokedGetWritingURLParametersList.contains { $0.withName == "informationFile.json" })
        XCTAssertTrue(localStorageMock.invokedGetWritingURLParametersList.contains { $0.withName == "photoFile.jpg" })
    }
    
    func testGetWritingURLCalledFromSave() {
        
        informationStorageManager.save(model: profileInformationMock) { _ in }
        
        XCTAssertTrue(localStorageMock.invokedGetWritingURL)
        XCTAssertEqual(localStorageMock.invokedGetWritingURLCount, 2)
        XCTAssertTrue(localStorageMock.invokedGetWritingURLParametersList.contains { $0.withName == "informationFile.json" })
        XCTAssertTrue(localStorageMock.invokedGetWritingURLParametersList.contains { $0.withName == "photoFile.jpg" })
    }
    
    private func build() -> InformationStorageManager {
        return InformationStorageManager(localStorage: localStorageMock)
    }

}
