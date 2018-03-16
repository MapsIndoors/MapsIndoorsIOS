//
//  MapsIndoors_Unit_Tests.swift
//  MapsIndoors Unit Tests
//
//  Created by Daniel Nielsen on 08/07/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

import XCTest
@testable import MapsIndoors

class MapsIndoors_Unit_Tests: XCTestCase {
    
    private let venues = MPVenueProvider()
    private let locations = MPLocationsProvider()
    private let solution = "550c26a864617400a40f0000"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        MapsIndoors.provideSolutionId(solution)
        MapsIndoors.setLanguage("en")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocations() {
        let expectation = self.expectation(description: "Locations Request")
        var hasFullfilled = false
        let query = MPLocationQuery()
        query.solutionId = solution
        query.types = ["Office"]
        query.query = "mapspeople sales"
        query.max = 1
        locations.getLocationsUsingQueryAsync(query, language: "en", completionHandler: { (locationData, error) in
            let names = locationData?.value(forKeyPath: "list.name") as! [String]?
            if let name = names?.first {
                if (name.caseInsensitiveCompare("mapspeople sales") == .orderedSame) {
                    if hasFullfilled == false {
                        expectation.fulfill()
                        hasFullfilled = true
                    }
                }
            }
        });
        waitForExpectations(timeout: 5.0, handler: {(_ error: Error?) -> Void in
            if error != nil {
                XCTFail("Expectation Failed with error: \(error.debugDescription)")
            }
        })
    }
    
    func testVenues() {
        let expectation = self.expectation(description: "Venues Request")
        var hasFullfilled = false
        venues.getVenuesAsync(solution, language: "en", completionHandler: { (venueCollection, error) in
            if error != nil {
                print("Error is: \(error.debugDescription)")
            }
            else if hasFullfilled == false {
                expectation.fulfill()
                hasFullfilled = true
            }
        })
        waitForExpectations(timeout: 5.0, handler: {(_ error: Error?) -> Void in
            if error != nil {
                XCTFail("Expectation Failed with error: \(error.debugDescription)")
            }
        })
    }
    
    func testBuildings() {
        let expectation = self.expectation(description: "Buildings Request")
        var hasFullfilled = false
        venues.getBuildingsAsync("all", arg: solution, language: "en", completionHandler: { (buildings, error) in
            if error != nil {
                print("Error is: \(error.debugDescription)")
            }
            else if hasFullfilled == false {
                expectation.fulfill()
                hasFullfilled = true
            }
        })
        waitForExpectations(timeout: 5.0, handler: {(_ error: Error?) -> Void in
            if error != nil {
                XCTFail("Expectation Failed with error: \(error.debugDescription)")
            }
        })
    }
    
    func testVenueRouting() {
        let expectation = self.expectation(description: "Routing Request")
        let routing = MPRoutingProvider()
        routing.solutionId = solution
        routing.venue = "rtx"
        let from = MPPoint(lat: 57.085289, lon: 9.957276, zValue: 0)
        let to = MPPoint(lat: 57.085887, lon: 9.956858, zValue: 0)
        routing.getRoutingFrom(from, to: to, by: "walking", avoid: nil) { (route, error) in
            if error != nil {
                print("Error is: \(error.debugDescription)")
            }
            else {
                
                expectation.fulfill()
                
                return
                
//                var i: Int = 0
//                for leg in route!.legs {
//                    let leg = leg as! MPRouteLeg
//                    let legStart = MPPoint(lat: leg.start_location.lat.doubleValue, lon: leg.start_location.lng.doubleValue, zValue: leg.start_location.zLevel.doubleValue)
//                    let legEnd = MPPoint(lat: leg.end_location.lat.doubleValue, lon: leg.end_location.lng.doubleValue, zValue: leg.end_location.zLevel.doubleValue)
//                    var startData: [AnyHashable: Any] = MPVenueProvider.getDataFrom(legStart, solutionId: self.solution, language: "en")
//                    var endData: [AnyHashable: Any] = MPVenueProvider.getDataFrom(legEnd, solutionId: self.solution, language: "en")
//                    let startVenue: MPVenue? = (startData["venue"] as? MPVenue)
//                    let startBuilding: MPVenue? = (startData["building"] as? MPVenue)
//                    let startFloor: MPVenue? = (startData["floor"] as? MPVenue)
//                    let endVenue: MPVenue? = (endData["venue"] as? MPVenue)
//                    let endBuilding: MPVenue? = (endData["building"] as? MPVenue)
//                    let endFloor: MPVenue? = (endData["floor"] as? MPVenue)
//                    i = i+1
//                    
//                    print("Leg \(i) Start:\nVenue: \(startVenue!.name), Building: \(startBuilding!.name), Floor: \(startFloor!.name)")
//                    print("Leg \(i) End:\nVenue: \(endVenue!.name), Building: \(endBuilding!.name), Floor: \(endFloor!.name)")
//                }
//                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10.0, handler: {(_ error: Error?) -> Void in
            if error != nil {
                XCTFail("Expectation Failed with error: \(error.debugDescription)")
            }
        })
    }
}

    
