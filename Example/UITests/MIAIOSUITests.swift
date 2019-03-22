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
    
    var solutionId:String?
    
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
        
        _ = addUIInterruptionMonitor(withDescription: "Any Dialog") { (alert) -> Bool in
            alert.buttons.element(boundBy: alert.buttons.count-1).tap()
            return true
        }
        
        let indexOfSolutionIdKey = app.launchArguments.index(of: "-solutionId")
        if indexOfSolutionIdKey != nil {
            self.solutionId = app.launchArguments[indexOfSolutionIdKey!+1]
            MapsIndoors.provideSolutionId(self.solutionId!)
        } else {
            let bundle = Bundle.init(for: MapsIndoors_App_UITests.self)
            if let fileUrl = bundle.url(forResource: "mapsindoors", withExtension: "plist"),
                let data = try? Data(contentsOf: fileUrl) {
                if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] { // [String: Any] which ever it is
                    self.solutionId = result!["MapsIndoorsAPIKey"] as? String
                    MapsIndoors.provideSolutionId(self.solutionId!)
                }
            }
        }
        
        let exp = expectation(description: "Expect test complete")
        
        
        
        MapsIndoors.fetchData { (error) in
            
            MPVenueProvider.init().getVenuesWithCompletion({ (venuesColl, vErr) in
                
                assert(venuesColl!.venues!.count > 0 && vErr == nil)
                
                MPLocationsProvider.init().getLocationsWithCompletion({ (locations, locError) in
                    
                    assert((locations!.list?.count)! > 0 && locError == nil)
                    
                    let venues:[MPVenue] = venuesColl!.venues as! [MPVenue]
                    
                    let from:MPLocation? = locations?.list?.filter({ (loc) -> Bool in
                        venues.first!.venueKey?.compare(loc.venue!.lowercased()) == .orderedSame
                    }).first
                    
                    let to:MPLocation? = locations?.list?.filter({ (loc) -> Bool in
                        venues.last!.venueKey?.compare(loc.venue!.lowercased()) == .orderedSame
                    }).last
                    
                    DispatchQueue.main.async {
                        
                        snapshot("0-Start-\(self.solutionId!)")
                        
                        if (app.tables.count == 0) {
                            app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0).tap()
                        }
                        if (app.searchFields.count == 0) {
                            app.tables.cells.element(boundBy: 0).tap()
                        }
                        
                        snapshot("1-Menu-\(self.solutionId!)")
                        
                        app.searchFields.element(boundBy: 0).tap()
                        app.searchFields.element(boundBy: 0).typeText(from!.name!)
                        
                        snapshot("2-Search-\(self.solutionId!)")
                        
                        app.tables.cells.element(boundBy: 0).tap()
                        
                        snapshot("3-Details-\(self.solutionId!)")
                        
                        app.buttons["Directions"].tap()
                        
                        snapshot("4-Directions-Init\(self.solutionId!)")
                        
                        let scrollViewsQuery = app.scrollViews
                        app/*@START_MENU_TOKEN@*/.buttons["chooseStartingPointButton"]/*[[".otherElements[\"dismiss popup\"]",".buttons[\"Choose starting point\"]",".buttons[\"chooseStartingPointButton\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
                        
                        app.searchFields.element(boundBy: 0).typeText(to!.name!)
                        
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
                })
            })
        }
        
        waitForExpectations(timeout: 300, handler: nil)
    }
}
