//
//  MyPositionProvider.swift
//  Demos
//
//  Created by Daniel Nielsen on 09/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class MyPositionProvider : NSObject, MPPositionProvider {
    
    override init() {
        providerType = .GPS_POSITION_PROVIDER
        locationServicesActive = false
        preferAlwaysLocationPermission = false
    }
    
    var preferAlwaysLocationPermission: Bool
    
    var locationServicesActive: Bool
    
    func requestLocationPermissions() {
        
    }
    
    func updateLocationPermissionStatus() {
        
    }
    
    func startPositioning(_ arg: String!) {
        
    }
    
    func stopPositioning(_ arg: String!) {
        
    }
    
    func startPositioning(after millis: Int32, arg: String!) {
        
    }
    
    func isRunning() -> Bool {
        return true
    }
    
    var delegate: MPPositionProviderDelegate!
    
    var latestPositionResult: MPPositionResult!
    
    var providerType: MPPositionProviderType
    
    
    
    
}
