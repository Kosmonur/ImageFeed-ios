//
//  ImageFeed_iosUITests.swift
//  ImageFeed-iosUITests
//
//  Created by Александр Пичугин on 18.07.2023.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = ["only_for_UITest"]
        app.launch()
    }
    
    func testAuth() throws {
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
            XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
            loginTextField.typeText("<e-mail>")
            webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
            XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
            passwordTextField.tap()
            passwordTextField.typeText("<password>")
            webView.swipeUp()
        
        webView.buttons.matching(identifier: "Login").element.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))

    }
    
    func testFeed() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        let tablesQuery = app.tables
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.swipeUp(velocity: .slow)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
        cell.swipeDown(velocity: .slow)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
        let cellToLikeButton = cellToLike.buttons["like_button"]
        cellToLikeButton.tap()
        sleep(1)

        cellToLikeButton.tap()
        sleep(1)
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 15))
        
        image.doubleTap()
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.tap()
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 2, velocity: 2)
        XCTAssertTrue(image.waitForExistence(timeout: 5))

        image.pinch(withScale: 0.5, velocity: -2)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        let navBackButton = app.buttons["nav_back_button"]
        navBackButton.tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Aleksandr Pichugin"].exists)
        XCTAssertTrue(app.staticTexts["@kosmonur"].exists)

        app.buttons["logout_button"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 1))
    }
}
