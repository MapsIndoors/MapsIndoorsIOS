//
//  MapsIndoors_App_UITests.swift
//  MapsIndoors App UITests
//
//  Created by Daniel Nielsen on 23/05/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

import XCTest
import MapsIndoors

class MapsIndoors_App_UITests: XCTestCase {
    
    var solutionId: String?
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        
        setupSnapshot(app)
        
        continueAfterFailure = false
       
        app.launch()
        
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSolution() {
        let app = XCUIApplication()

        let interruptionToken = addUIInterruptionMonitor(withDescription: "LocationService permission") { (alert) -> Bool in
            let button = alert.buttons["Allow While Using App"]
            if button.exists {
                button.tap()
                return true // The alert was handled
            }

            return false // The alert was not handled
        }
        
        _ = app.wait(for: .runningForeground, timeout: 10)
        app.tap()

        if let indexOfSolutionIdKey = app.launchArguments.firstIndex(of: "-solutionId") {
            self.solutionId = app.launchArguments[indexOfSolutionIdKey + 1]
            MapsIndoors.provideAPIKey(self.solutionId!, googleAPIKey: nil)
        } else {
            let bundle = Bundle(for: MapsIndoors_App_UITests.self)
            if let fileUrl = bundle.url(forResource: "mapsindoors", withExtension: "plist"),
                let data = try? Data(contentsOf: fileUrl) {
                if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] { // [String: Any] which ever it is
                    self.solutionId = result["MapsIndoorsAPIKey"] as? String
                    MapsIndoors.provideAPIKey(self.solutionId!, googleAPIKey: nil)
                }
            }
        }
        
        let exp = expectation(description: "Expect test complete")
        
        MapsIndoors.synchronizeContent { error in
            MPVenueProvider().getVenuesWithCompletion { venuesColl, vErr in
                XCTAssertNil(vErr)
                XCTAssertTrue(venuesColl?.venues?.count ?? 0 > 0)

                let venues = venuesColl!.venues as! [MPVenue]
                let filter = MPFilter()
                filter.types = ["MeetingRoom", "Workstation", "Office"]
                filter.parents = [venues.first!.venueId!]
                filter.depth = 4
                MPLocationService.sharedInstance().getLocationsUsing(MPQuery(), filter: filter) { locations, locError in
                    XCTAssertNil(locError)
                    XCTAssertTrue(locations?.count ?? 0 > 0)

                    let from = locations?.first
                    let to = locations?.last
                    
                    DispatchQueue.main.async {
                        snapshot("0-Start-\(self.solutionId!)")
                        
                        if (app.tables.count == 0) {
                            app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0).tap()
                        }
                        if (app.searchFields.count == 0) {
                            app.tables.cells.element(boundBy: 0).tap()
                        }
                        
                        snapshot("1-Menu-\(self.solutionId!)")

                        let toSearchField = app.searchFields.element(boundBy: 0)
                        toSearchField.tap()
                        toSearchField.typeText(to!.name!)

                        snapshot("2-Search-\(self.solutionId!)")
                        
                        app.tables.cells.element(boundBy: 0).tap()
                        
                        snapshot("3-Details-\(self.solutionId!)")
                        
                        app.buttons["Directions"].tap()
                        
                        snapshot("4-Directions-Init\(self.solutionId!)")
                        
                        app/*@START_MENU_TOKEN@*/.buttons["chooseStartingPointButton"]/*[[".otherElements[\"dismiss popup\"]",".buttons[\"Choose starting point\"]",".buttons[\"chooseStartingPointButton\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

                        let fromSearchField = app.searchFields.element(boundBy: 0)
                        fromSearchField.tap()
                        fromSearchField.typeText(from!.name!)

                        snapshot("5-Choose-Origin-\(self.solutionId!)")
                        
                        app.tables.cells.element(boundBy: 0).tap()
                        
                        snapshot("6-Directions-Route-\(self.solutionId!)")
                        
                        //scrollViewsQuery.otherElements.containing(.image, identifier:"empty_icon.png").children(matching: .button).element(boundBy: 1).tap()
                        app/*@START_MENU_TOKEN@*/.buttons["switchDirButton"]/*[[".otherElements[\"dismiss popup\"].buttons[\"switchDirButton\"]",".otherElements[\"PopoverDismissRegion\"].buttons[\"switchDirButton\"]",".buttons[\"switchDirButton\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                        
                        snapshot("7-Directions-Inverted-\(self.solutionId!)")
                        
                        ///Start horizontal directions
                        if (app.buttons["Show on map"].exists) {
                            app.buttons["Show on map"].tap()
                            snapshot("8-Directions-On-Map-\(self.solutionId!)")
                        }
                        
                        let icChevronRightButton = app.buttons["Next"]
                        if (icChevronRightButton.exists) {
                            icChevronRightButton.tap()
                            icChevronRightButton.tap()
                            icChevronRightButton.tap()
                            snapshot("9-Directions-On-Map-\(self.solutionId!)")
                        }
                        
                        exp.fulfill()
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 300)
        removeUIInterruptionMonitor(interruptionToken)
    }
}
