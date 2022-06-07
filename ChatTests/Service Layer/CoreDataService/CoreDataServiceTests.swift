//
//  CoreDataServiceTests.swift
//  ChatTests
//
//  Created by Macbook on 19.05.2022.
//

import XCTest
import CoreData
@testable import iOS_Chat

class CoreDataServiceTests: XCTestCase {

    private let coreDataStackMock = CoreDataStackMock()
    private let channelMock = ChannelModel(identifier: "", name: "", message: nil, date: nil)
    private lazy var coreDataService = build()
    
    func testPerformSaveCalledFromSaveChannel() {
        coreDataService.saveChannel(channel: channelMock)
        
        XCTAssertTrue(coreDataStackMock.invokedPerformSaveOnViewContext)
        XCTAssertEqual(coreDataStackMock.invokedPerformSaveOnViewContextCount, 1)
    }
    
    func testFetchOnViewContextCalledFromSaveChannel() {
        coreDataService.saveChannel(channel: channelMock)
        
        XCTAssertTrue(coreDataStackMock.invokedFetchOnViewContext)
        XCTAssertEqual(coreDataStackMock.invokedFetchOnViewContextCount, 1)
    }
    
    private func build() -> CoreDataService {
        return CoreDataService(coreDataStack: coreDataStackMock)
    }
}
