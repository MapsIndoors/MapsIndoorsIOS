//
//  AppLinkTests.swift
//  MIAIOSUITests
//
//  Created by Daniel Nielsen on 09/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

import XCTest

class AppLinkTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppLinkForDirections() {
        let url = "mapsindoors://57e4e4992e74800ef8b69718/directions?originLocation=21ffaa29fdfa4a5491bb0379&destinationLocation=3002f54bae4d4c4e8ecce4a1"
        
        openUrlInSafari(url: url)
        
        let app = XCUIApplication()

        let predicate = NSPredicate(format: "label CONTAINS[c] 'Start Route from Marrakech'")
        
        let routeCalculated = app.buttons.containing(predicate).firstMatch.waitForExistence(timeout: 15)
        
        XCTAssert(routeCalculated)
    }
    
    func testAppLinkForDirectionsOnColdLaunch() {
        let app = XCUIApplication()

        app.terminate()
        
        testAppLinkForDirections()
    }

    func openUrlInSafari(url:String) {
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        safari.terminate()
        safari.launch()

        _ = safari.wait(for: .runningForeground, timeout: 10)
        
        safari.textFields["Address"].tap()
        safari.typeText(url)
        safari.buttons["Go"].tap()
        
        safari.buttons["Open"].tap()

        let app = XCUIApplication()
        
        _ = app.wait(for: .runningForeground, timeout: 15)
        
        if app.alerts.firstMatch.exists {
            app.alerts.firstMatch.buttons["Cancel"].tap()
        }
    }
}
