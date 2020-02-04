//
//  MyPositionProvider.swift
//  Demos
//
//  Created by Daniel Nielsen on 09/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

/***
 ---
 title: Show the Blue Dot with MapsIndoors - Part 1
 ---
 
 In this tutorial we will show how you can show a blue dot on the map, representing the users location. The position will be served from a mocked positioning provider and displayed on a map in a view controller.
 
 We will start by creating our implementation of a positioning provider.
 
 Create a class `MyPositionProvider` that inherits from NSObject and implements `MPPositionProvider`.
 ***/
class MyPositionProvider : NSObject, MPPositionProvider {
    
    /***
     Add some member variables to `MyPositionProvider`.
     
     * `delegate`: The delegate object
     * `running`: A running state boolean flag
     * `latestPositionResult`: The latest positioning result
     * `preferAlwaysLocationPermission`: A boolean that indicates whether this provider requires Apple Location Services to always be active
     * `locationServicesActive`: A boolean that indicates whether Apple Location Services is currently active
     * `providerType`: A provider type enum, convenient when working with multiple positioning providers in the same application
     ***/
    var delegate: MPPositionProviderDelegate?
    private var running = false
    var latestPositionResult: MPPositionResult?
    var preferAlwaysLocationPermission: Bool = false
    var locationServicesActive: Bool = false
    var providerType: MPPositionProviderType = .GPS_POSITION_PROVIDER
    var heading:Double = 0
   
    /***
     Create a method called `updatePosition`. This will be our "loop" constantly posting a new position to the delegate.
     
     * Check if the provider has a running state
     * Assign a new `MPPositionResult` to `latestPositionResult`
     * Assign a new position point
     * Optionally specify that heading is available and set a heading
     * Notify the delegate by calling `onPositionUpdate` passing the new position as argument
     * Schedule a new delayed call of this method
     ***/
    private func updatePosition() {
        if running {
            latestPositionResult = MPPositionResult.init()
            latestPositionResult?.geometry = MPPoint.init(lat: 57.057964, lon: 9.9504112)
            latestPositionResult?.provider = self
            latestPositionResult?.headingAvailable = true
            heading = (heading + 10).truncatingRemainder(dividingBy: 360)
            latestPositionResult?.setHeadingDegrees(heading)
            
            if let delegate = self.delegate, let latestPositionResult = self.latestPositionResult {
                delegate.onPositionUpdate(latestPositionResult)
            }
            
            weak var _self = self
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                _self?.updatePosition()
            }
        }
    }
    
    /***
     Implement the `requestLocationPermissions` method. In this example we will just set the `locationServicesActive` to true.
     ***/
    func requestLocationPermissions() {
        locationServicesActive = true
    }
    
    /***
     Implement the `updateLocationPermissionStatus` method. In this example we will just set the `locationServicesActive` to true.
     ***/
    func updateLocationPermissionStatus() {
        locationServicesActive = true
    }
    
    /***
     Implement the `startPositioning` method. We set the `running` boolean to true and call `updatePos`.
     ***/
    func startPositioning(_ arg: String?) {
        running = true
        updatePosition()
    }
    
    /***
     Implement the `stopPositioning` method. We set the `running` boolean to false.
     ***/
    func stopPositioning(_ arg: String?) {
        running = false
    }
    
    /***
     Implement the `startPositioningAfter` method. This is just a convenience method that should support a delayed start.
     ***/
    func startPositioning(after millis: Int32, arg: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.001 * Double(millis))) {
            self.startPositioning(arg)
        }
    }
    
    /***
     Implement the `isRunning` method. Return the value of `running`.
     ***/
    func isRunning() -> Bool {
        return running
    }
    
    /***
     In [Part 2](../showmylocationshowmylocationcontroller) we will create the map view controller that displays the blue dot.
     ***/
    //
}
