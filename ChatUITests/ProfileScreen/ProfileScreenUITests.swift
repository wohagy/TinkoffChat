//
//  ProfileScreenUITests.swift
//  ChatUITests
//
//  Created by Macbook on 18.05.2022.
//

import XCTest

class ProfileScreenUITests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }
    
    func testProfileScreenMainElements() throws {
        
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Channels"].buttons["profileSettingButton"].tap()
        
        XCTAssertTrue(app.otherElements["profileInfoView"].waitForExistence(timeout: 10))
        
        XCTAssertTrue(app.images["profilePhotoImageView"].exists)
        XCTAssertTrue(app.staticTexts["profileNameLabel"].exists)
        XCTAssertTrue(app.textViews["profileBioTextView"].exists)
        XCTAssertTrue(app.staticTexts["profileLocationLabel"].exists)
        XCTAssertTrue(app.buttons["editProfileInfoButton"].exists)
        
        app.buttons["editProfileInfoButton"].tap()
        
        XCTAssertTrue(app.images["profilePhotoImageView"].exists)
        XCTAssertTrue(app.buttons["editProfilePhotoButton"].exists)
        XCTAssertTrue(app.textFields["profileNameTextField"].exists)
        XCTAssertTrue(app.textViews["profileBioTextView"].exists)
        XCTAssertTrue(app.textFields["profileLocationTextField"].exists)
        XCTAssertTrue(app.buttons["saveProfileInfoChangesButton"].exists)
        XCTAssertTrue(app.buttons["cancelProfileInfoChangesButton"].exists)
    }
}
