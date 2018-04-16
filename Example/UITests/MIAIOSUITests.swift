//
//  MapsIndoors_App_UITests.swift
//  MapsIndoors App UITests
//
//  Created by Daniel Nielsen on 23/05/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

import XCTest
import MapsIndoors

class MapsIndoors_App_UITests: XCTestCase {
    
    var solutionId:String?
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        
        setupSnapshot(app)
        
        do {
            let bundle = Bundle.init(for: MapsIndoors_App_UITests.self)
            self.solutionId = try String(contentsOfFile: bundle.path(forResource: "solution", ofType: "txt")!).replacingOccurrences(of: "\n", with: "")
            app.launchEnvironment = ["MI_SOLUTION_ID": self.solutionId!]
            MapsIndoors.provideAPIKey(self.solutionId!, googleAPIKey: "")
        } catch {
        }
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testApp() {
        
        let exp = expectation(description: "Expect test complete")
        
        var ensuredSingleRun = false;
        
        MapsIndoors.synchronizeContent( { (offlineErr) in
            
            MPVenueProvider().getVenuesWithCompletion( { (venuesColl, vErr) in
                
                MPLocationsProvider().getLocationsWithCompletion( { (locationData, locError) in
                    
                    MPCategoriesProvider().getCategoriesWithCompletion( { (categories, catError) in
                    
                        if (ensuredSingleRun) {
                            return;
                        } else {
                            ensuredSingleRun = true;
                        }
                        
                        DispatchQueue.main.async {
                            
                            let app = XCUIApplication()
                            
                            snapshot("0-Start-\(self.solutionId!)")
                            
                            print( "app.tables.count = \(app.tables.count)" )
                            if app.tables.count == 0 {
                                app.navigationBars.element(boundBy: 0).children(matching: .button).element.tap()
                            } else {
                                app.tables.cells.element(boundBy: 0).tap()
                            }
                            
                            app/*@START_MENU_TOKEN@*/.navigationBars["Select Venue"]/*[[".otherElements[\"dismiss popup\"].navigationBars[\"Select Venue\"]",".otherElements[\"PopoverDismissRegion\"].navigationBars[\"Select Venue\"]",".navigationBars[\"Select Venue\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["venue_button_id"].tap()
                            
                            snapshot("1-Venue-Selection-\(self.solutionId!)")
                            
                            app.tables.cells.element(boundBy: 0).tap()
                            
                            snapshot("2-Menu-\(self.solutionId!)")
                            
                            app.searchFields.element(boundBy: 0).tap()
                            
                            let location = locationData?.list[0]
                            app.searchFields.element(boundBy: 0).typeText(location!.name)
                            
                            snapshot("3-Search-\(self.solutionId!)")
                            
                            app.tables.cells.element(boundBy: 0).tap()
                            
                            snapshot("4-Details-\(self.solutionId!)")
                            
                            app.buttons["Show on map"].tap()
                            
                            snapshot("5-Show-On-Map-\(self.solutionId!)")
                            
                            app.navigationBars.element(boundBy: 0).children(matching: .button).element(boundBy: 0).tap()
                            
                            app.buttons["Directions"].tap()
                            
                            snapshot("6-Directions-Init\(self.solutionId!)")
                            
                            let scrollViewsQuery = app.scrollViews
                            let sv = scrollViewsQuery.element(boundBy: 0)
                            sv.swipeDown()
                            let elementsQuery = scrollViewsQuery.otherElements
                            let btn = elementsQuery.buttons["chooseStartingPointButton"]
                            btn.tap()

                            app.navigationBars["NoCancelButtonSearch"].searchFields["Search"].typeText((locationData?.list[1].name)!)
                            
                            snapshot("7-Choose-Origin-\(self.solutionId!)")
                            
                            app.tables.cells.element(boundBy: 0).tap()
                            
                            snapshot("8-Directions-Route-\(self.solutionId!)")
                            
                            scrollViewsQuery.otherElements.containing(.image, identifier:"empty_icon.png").children(matching: .button).element(boundBy: 1).tap()
                            
                            snapshot("9-Directions-Inverted-\(self.solutionId!)")
                            
                            if (app.otherElements.staticTexts["▼ Directions"].exists) {
                                app.otherElements.staticTexts["▼ Directions"].tap()
                            }
                            
                            app.buttons["Show on map"].tap()
                            
                            snapshot("10-Directions-On-Map\(self.solutionId!)")
                            
                            let icChevronRightButton = app.buttons["ic chevron right"]
                            icChevronRightButton.tap()
                            icChevronRightButton.tap()
                            icChevronRightButton.tap()
                            
                            exp.fulfill()
                        }
                    })
                })
            })
        })
        
        waitForExpectations(timeout: 3000, handler: nil)
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
