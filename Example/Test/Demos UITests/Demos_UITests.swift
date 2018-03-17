//
//  Demos_UITests.swift
//  Demos UITests
//
//  Created by Daniel Nielsen on 17/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import XCTest

class Demos_UITests: XCTestCase {
        
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
    
    func testDemos() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show Location Demo"]/*[[".cells.staticTexts[\" Show Location Demo\"]",".staticTexts[\" Show Location Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowLocation"].buttons["MapsIndoors Demos"].tap()
        tablesQuery.staticTexts[" Location Details Demo"].tap()
        app.navigationBars["Demos.LocationDetails"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show Multiple Locations Demo"]/*[[".cells.staticTexts[\" Show Multiple Locations Demo\"]",".staticTexts[\" Show Multiple Locations Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowMultipleLocations"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show Route Demo"]/*[[".cells.staticTexts[\" Show Route Demo\"]",".staticTexts[\" Show Route Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowRoute"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show Venue Demo"]/*[[".cells.staticTexts[\" Show Venue Demo\"]",".staticTexts[\" Show Venue Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowVenue"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show Building Demo"]/*[[".cells.staticTexts[\" Show Building Demo\"]",".staticTexts[\" Show Building Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowBuilding"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show Floor Demo"]/*[[".cells.staticTexts[\" Show Floor Demo\"]",".staticTexts[\" Show Floor Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowFloor"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Change Display Setting Demo"]/*[[".cells.staticTexts[\" Change Display Setting Demo\"]",".staticTexts[\" Change Display Setting Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ChangeDisplaySetting"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Custom Floor Selector Demo"]/*[[".cells.staticTexts[\" Custom Floor Selector Demo\"]",".staticTexts[\" Custom Floor Selector Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Stigsborgvej - Floor 0"].buttons["Floor"].tap()
        app.alerts["Select Floor"].buttons["Floor 1 "].tap()
        app.navigationBars["Stigsborgvej - Floor 1"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Show My Location Demo"]/*[[".cells.staticTexts[\" Show My Location Demo\"]",".staticTexts[\" Show My Location Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.ShowMyLocation"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Multiple Datasets Demo"]/*[[".cells.staticTexts[\" Multiple Datasets Demo\"]",".staticTexts[\" Multiple Datasets Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Aalborg City"]/*[[".cells.staticTexts[\"Aalborg City\"]",".staticTexts[\"Aalborg City\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let backButton = app.navigationBars["Demos.DatasetView"].buttons["Back"]
        backButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Stigsborgvej"]/*[[".cells.staticTexts[\"Stigsborgvej\"]",".staticTexts[\"Stigsborgvej\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        app.navigationBars["Demos.MultipleDatasets"].buttons["MapsIndoors Demos"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[" Search Map Demo"]/*[[".cells.staticTexts[\" Search Map Demo\"]",".staticTexts[\" Search Map Demo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Search"].tap()
        app.tables.element(boundBy: 0).children(matching: .searchField).element.tap()
        app.searchFields.element(boundBy: 0).typeText("paris")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Paris"]/*[[".cells.staticTexts[\"Paris\"]",".staticTexts[\"Paris\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Demos.SearchMap"].buttons["MapsIndoors Demos"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
