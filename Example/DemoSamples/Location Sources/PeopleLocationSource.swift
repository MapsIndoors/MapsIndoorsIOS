//
//  PeopleLocationSource.swift
//  Demos
//
//  Created by Daniel Nielsen on 29/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

/***
 ---
 title: Creating your own Location Sources - Part 1
 ---
 
 In this tutorial we will show how you can build a custom Location Source, representing locations of people. The people locations will be served from a mocked list in the source and displayed on a map in a view controller.
 
 We will start by creating our implementation of a location source.
 
 Create a class `PeopleLocationsDataSource` that inherits from NSObject and implements `MPLocationSource`.
 ***/


class PeopleLocationSource : NSObject, MPLocationSource {
    
    /***
     Add some member variables to `PeopleLocationsDataSource`.
     
     * `observers`: The observer objects that we will notify about changes
     * `locationUpdates`: A list of MPLocationUpdate - the MPLocation builders
     * `locationPoints`: A list of MPPoint - the positions that we will mock
     * `locationDirs`: A list of directions - the walking direction for each "person"
     * `queue`: A backround queue
     * `numberOfPeople`: The number of people to mock
     ***/
    private var observers = [MPLocationsObserver]()
    private var locationUpdates = [MPLocationUpdate]()
    private var locationPoints = [MPPoint]()
    private var locationDirs = [Double]()
    private let queue = DispatchQueue.init(label: "UpdatePositions")
    private let numberOfPeople = 100
    
    
    /***
     Create a method called `getRandomPoint` that simply just returns a random point (here within proximity of the demo venue)
     ***/
    func getRandomPoint() -> MPPoint {
        let lat = 57.058037 + Double.random(in: -0.0004 ..< 0.0004)
        let lng = 9.950572 + Double.random(in: -0.0004 ..< 0.0004)
        return MPPoint.init(lat: lat, lon: lng, zValue: 1)
    }
    
    
    /***
     Create a method called `createPeople` that takes a type string. Iterate numberOfPeople and for each iteration create:
     
     * An MPLocationUpdate with an id and a source (self)
     * A type - later used to style the location
     * A floor
     * A random point and initial direction for the person
     ***/
    func createPeople(_ type: String) {
        for locId in 0 ..< numberOfPeople {
            
            let locationUpdate = MPLocationUpdate.init(id: locId, from: self)
            
            locationUpdate.type = type
            locationUpdate.addPropertyValue("John Doe #\(locId)", forKey: MPLocationFieldName)
            locationUpdate.floor = 10
            let p = getRandomPoint()
            locationPoints.append(p)
            locationDirs.append(Double.random(in: 0 ..< 360))
            locationUpdate.position = p.getCoordinate()
            locationUpdates.append(locationUpdate)
            
        }
    }
    
    
    /***
     Create a method called `updatePositions`. Iterate numberOfPeople again and for each iteration:
     * Get the corresponding MPLocationUpdate
     * Set a new position using Google Maps' offsetting function
     * Save a new heading and position
     * Generate MPLocation from the MPLocationUpdate
     After iteration, notify each observer about the updates locations
     ***/
    func updatePositions() {
        var updatedLocations = [MPLocation]()
        for locId in 0 ..< numberOfPeople {
            let locationUpdate = locationUpdates[locId]
            let newPos = GMSGeometryOffset(locationPoints[locId].getCoordinate(), 0.5, locationDirs[locId])
            locationUpdate.position = newPos
            locationDirs[locId] = locationDirs[locId] + Double.random(in: -22 ..< 22)
            locationPoints[locId] = MPPoint.init(lat: newPos.latitude, lon: newPos.longitude)
            updatedLocations.append(locationUpdate.location())
        }
        for observer in observers {
            observer.onLocationsUpdate(updatedLocations, source: self)
        }
        weak var _self = self
        queue.asyncAfter(deadline: .now() + 0.5) {
            _self?.updatePositions()
        }
    }
    
    
    /***
     Create a method called `startMockingPositions` that simply just calls `updatePositions` in the future.
     ***/
    func startMockingPositions() {
        weak var _self = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            _self?.updatePositions()
        }
    }
    
    
    /***
     Create an initialiser that takes a type string. Call `createPeople` and `startMockingPositions`.
     ***/
    convenience init(type:String) {
        
        self.init()
        
        createPeople(type)
        
        startMockingPositions()
    }
    
    
    /***
     Implement the MPLocationSource method `getAllLocations`. For this demo just return an empty array as each update will also contain the full list of locations.
     ***/
    func getLocations() -> [MPLocation] {
        return []
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
        return 0;
    }
    
    //
    
}

/***
 In [Part 2](../locationsourcesroomavailabilitysource) we will create a view controller displaying a map that shows the mocked people locations on top of a MapsIndoors map.
 ***/
