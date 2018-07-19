//
//  MessagesTaskUITests.swift
//  MessagesTaskUITests
//
//  Created by Krysta Deluca on 7/19/18.
//  Copyright © 2018 Krysta Deluca. All rights reserved.
//

import XCTest

class MessagesTaskUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogIn() {
        let app = XCUIApplication()
        app.buttons["LogInButton"].tap()
        
        app.textFields["EmailTextField"].typeText("test@test.com")
        app.textFields["PasswordTextField"].tap()
        app.textFields["PasswordTextField"].typeText("password")
        
        app.buttons["LogInButton"].tap()
        
        XCTAssert(app.navigationBars["Messages"].exists)
    }
    
    func testSignUp() {
        let app = XCUIApplication()
        let randomNum:UInt32 = arc4random_uniform(100)
        let num: Int = Int(randomNum)
        app.buttons["SignUpButton"].tap()
        
        app.textFields["NameTextField"].typeText("Bella")
        app.textFields["EmailTextField"].tap()
        app.textFields["EmailTextField"].typeText("test\(num)@test.com")
        app.textFields["PasswordTextField"].tap()
        app.textFields["PasswordTextField"].typeText("password")
        
        app.buttons["SignUpButton"].tap()
        
        XCTAssert(app.navigationBars["Messages"].exists)
    }
    
    func testUserSelection() {
        let app = XCUIApplication()
        app.buttons["LogInButton"].tap()
        
        app.textFields["EmailTextField"].typeText("test@test.com")
        app.textFields["PasswordTextField"].tap()
        app.textFields["PasswordTextField"].typeText("password")
        
        app.buttons["LogInButton"].tap()
        
        app.navigationBars["Messages"].buttons["Add"].tap()
        
        //Depending on current state of cell, test tapping on cell selects or deselects it
        app.tables.cells.element(boundBy: 0).accessoryType == .checkmark
        if app.tables.cells.element(boundBy: 0).isSelected {
            let cellQuery = app.tables.cells.element(boundBy: 0)
            cellQuery.tap()
            
            XCTAssertFalse(app.tables.cells.element(boundBy: 0).isSelected)
            
            cellQuery.tap()
            XCTAssertTrue(app.tables.cells.element(boundBy: 0).isSelected)
        } else {
            let cellQuery = app.tables.cells.element(boundBy: 0)
            cellQuery.tap()
            
            XCTAssertTrue(app.tables.cells.element(boundBy: 0).isSelected)

            cellQuery.tap()
            XCTAssertFalse(app.tables.cells.element(boundBy: 0).isSelected)
        }
    }
    
}
