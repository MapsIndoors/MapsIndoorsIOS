//
//  MapsIndoors_UI_Tests.swift
//  MapsIndoors UI Tests
//
//  Created by Daniel Nielsen on 08/07/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

import XCTest

class MapsIndoors_UI_Tests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApp() {
        
        let app = XCUIApplication()
        
        if (app.alerts.count > 0 && app.alerts.buttons.element(boundBy: 1).isHittable) {
            app.alerts.buttons.element(boundBy: 1).tap()
        }
        if (app.alerts.count > 0 && app.alerts.buttons.element(boundBy: 1).isHittable) {
            app.alerts.buttons.element(boundBy: 1).tap()
        }
        if app.tables.cells.element(boundBy: 0).isHittable {
            app.tables.cells.element(boundBy: 0).tap()
        }
        app.navigationBars["RTX"].children(matching: .button).element.tap()
        
        app.searchFields.element(boundBy: 0).tap()
        app.searchFields["Search"].typeText("Maps")
        
        wait(for: 2)
        
        app.tables.cells.element(boundBy: 0).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        app.buttons["Get directions"].tap()
        
        if (app.tables.buttons["My position"].exists) {
            app.tables.buttons["My position"].tap()
        } else {
            app.tables.buttons["Origin"].tap()
        }
        
        let searchSearchField = app.searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.typeText("reception")
        
        wait(for: 2)
        
        app.tables.cells.element(boundBy: 0).tap()
        app.buttons["Show on map"].tap()
        app.navigationBars["Get directions"].children(matching: .button).element(boundBy: 1).tap()
        
    }
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
    
}
