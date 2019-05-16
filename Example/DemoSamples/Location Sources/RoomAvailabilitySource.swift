//
//  RoomAvailabilitySource.swift
//  Demos
//
//  Created by Daniel Nielsen on 16/05/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

/***
 ---
 title: Creating your own Location Sources - Part 2
 ---
 
 This is part 2 of the tutorial of building custom Location Sources. In [Part 1](locationsourcespeoplelocationsource) we created a people location source that mocks locations of people. Now we will create another location source that mocks the availability of meeting rooms or work desks.
 
 This location source rely on MapsIndoors data, so we will consume the locations of `MPMapsIndoorsLocationSource` and relay them as this source's own locations. Thus we need to observe the `MPMapsIndoorsLocationSource` and act as a LocationSource at the same time.
 
 Create a class `RoomAvailabilitySource` that inherits from NSObject and implements `MPLocationSource` and `MPLocationsObserver`.
 ***/


class RoomAvailabilitySource : NSObject, MPLocationSource, MPLocationsObserver {
    
    /***
     Add some member variables to `RoomAvailabilitySource`.
     * `observers`: The observer objects that we will notify about changes
     * `locationUpdates`: A dictionary of reusable `MPLocationUpdate` models
     * `miMapsIndoorsSource`: The MapsIndoors source to observe
     ***/
    private var observers = [MPLocationsObserver]()
    private var locationUpdates = Dictionary<String, MPLocationUpdate>()
    private let miMapsIndoorsSource:MPLocationSource = MPMapsIndoorsLocationSource()
    
    /***
     In the initialiser, add this instance as observer for The MapsIndoors source.
     ***/
    override init() {
        super.init()
        self.miMapsIndoorsSource.add(self)
    }
    
    /***
     Create a method `updateIconForLocation` that takes a location and grabs or creates a location update object. Randomly modify the icon of that location so it looks occupied.
     ***/
    func updateIconForLocation(location:MPLocation) -> MPLocationUpdate? {
        if locationUpdates[location.locationId!] == nil {
            locationUpdates[location.locationId!] = MPLocationUpdate.init(location: location)
        }
        let locUpdate = locationUpdates[location.locationId!]
        
        if (Int.random(in: 0...1) == 0) {
            locUpdate?.icon = UIImage(named: "closed")!
        }
        return locUpdate
    }
        
    /***
     Create a method `updateLocations` that runs through a list of locations add creates location update objects.
     ***/
    func updateLocations(locations:[MPLocation]) -> [MPLocation] {
        
        var updatedLocations = [MPLocation]()
        
        for location in locations {
            if let locUpdate = updateIconForLocation(location: location) {
                updatedLocations.append(locUpdate.location())
            }
        }
        
        return updatedLocations
    }
    
    /***
     Implement the MPLocationSource method `getLocations`. For this demo just return the full list of MapsIndoors' locations.
     ***/
    func getLocations() -> [MPLocation] {
        return miMapsIndoorsSource.getLocations()
    }
    
    
    /***
     Implement the MPLocationSource method `addLocationObserver`.
     ***/
    func add(_ observer: MPLocationsObserver) {
        observers.append(observer)
    }
    
    
    /***
     Implement the MPLocationSource method `removeLocationObserver`.
     ***/
    func remove(_ observer: MPLocationsObserver) {
        observers = observers.filter({ (obsvr) -> Bool in
            return obsvr !== observer
        })
    }
    
    
    /***
     Implement the MPLocationSource method `sourceStatus`.
     ***/
    func status() -> MPLocationSourceStatus {
        return .available
    }
    
    
    /***
     Implement the MPLocationSource method `sourceIdentifier`.
     ***/
    func sourceId() -> Int32 {
        return 2;
    }
    
    /***
     Relay `onLocationsDelete` events to this sources own observers.
     ***/
    func onLocationsDelete(_ locations: [String], source: MPLocationSource) {
        for obsvr in observers {
            obsvr.onLocationsDelete(locations, source: self)
        }
    }
    
    /***
     In `onLocationsUpdate` create new modified locations objects and call the observers.
     ***/
    func onLocationsUpdate(_ locationUpdates: [MPLocation], source: MPLocationSource) {
        let locations = updateLocations(locations: locationUpdates)
        for obsvr in observers {
            obsvr.onLocationsUpdate(locations, source: self)
        }
    }
    
    /***
     Relay `onStatusChange` events to this sources own observers.
     ***/
    func onStatusChange(_ status: MPLocationSourceStatus, source: MPLocationSource) {
        for obsvr in observers {
            obsvr.onStatusChange(status, source: self)
        }
    }
    
    //
}

/***
 In [Part 3](../locationsourceslocationsourcesmapcontroller) we will create a view controller that shows the people and room locations on top of a MapsIndoors map.
 ***/
