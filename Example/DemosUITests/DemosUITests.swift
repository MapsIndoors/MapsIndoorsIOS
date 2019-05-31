//
//  DemosUITests.swift
//  DemosUITests
//
//  Created by Michael Bech Hansen on 05/04/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import XCTest

class DemosUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    fileprivate func wait(_ app: XCUIApplication) {
        _ = app.wait(for: .notRunning, timeout: 1)
    }
    
    func testSet1() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show Location Demo"]/*[[".cells.staticTexts[\" Show Location Demo\"]",".staticTexts[\" Show Location Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Location Details Demo"]/*[[".cells.staticTexts[\" Location Details Demo\"]",".staticTexts[\" Location Details Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show Multiple Locations Demo"]/*[[".cells.staticTexts[\" Show Multiple Locations Demo\"]",".staticTexts[\" Show Multiple Locations Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show Route Demo"]/*[[".cells.staticTexts[\" Show Route Demo\"]",".staticTexts[\" Show Route Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.staticTexts["Show leg 0, all steps"].tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show Venue Demo"]/*[[".cells.staticTexts[\" Show Venue Demo\"]",".staticTexts[\" Show Venue Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show Building Demo"]/*[[".cells.staticTexts[\" Show Building Demo\"]",".staticTexts[\" Show Building Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show Floor Demo"]/*[[".cells.staticTexts[\" Show Floor Demo\"]",".staticTexts[\" Show Floor Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Change Display Setting Demo"]/*[[".cells.staticTexts[\" Change Display Setting Demo\"]",".staticTexts[\" Change Display Setting Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Custom Floor Selector Demo"]/*[[".cells.staticTexts[\" Custom Floor Selector Demo\"]",".staticTexts[\" Custom Floor Selector Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars["Stigsborgvej - Floor 0"].buttons["Floor"].tap()
        wait(app)
        app.alerts["Select Floor"].buttons["Floor 1 "].tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        wait(app)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Show My Location Demo"]/*[[".cells.staticTexts[\" Show My Location Demo\"]",".staticTexts[\" Show My Location Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        wait(app)
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Search Map Demo"]/*[[".cells.staticTexts[\" Search Map Demo\"]",".staticTexts[\" Search Map Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.buttons["Search"].tap()
        wait(app)
        app.searchFields.firstMatch.tap()
        wait(app)
        app.searchFields.firstMatch.typeText("park")
        tablesQuery.staticTexts["Parking 1, , , Stigsborgvej"].tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        wait(app)
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Multiple Datasets Demo"]/*[[".cells.staticTexts[\" Multiple Datasets Demo\"]",".staticTexts[\" Multiple Datasets Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Stigsborgvej"]/*[[".cells.staticTexts[\"Stigsborgvej\"]",".staticTexts[\"Stigsborgvej\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        wait(app)
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Aalborg City"]/*[[".cells.staticTexts[\"Aalborg City\"]",".staticTexts[\"Aalborg City\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
        wait(app)
        app.navigationBars.buttons.firstMatch.tap()
    }
}
