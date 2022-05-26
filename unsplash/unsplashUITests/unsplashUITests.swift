//
//  unsplashUITests.swift
//  unsplashUITests
//
//  Created by macOS on 5/27/22.
//

import XCTest

class unsplashUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("office")
        
        app.collectionViews.element.tap()
    }
}
