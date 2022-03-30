//
//  ViewController.swift
//  SimpleMapSwift
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors

class ShowBuildingController: UIViewController {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        let locationService = MPLocationService.sharedInstance()
        let query = MPQuery.init()
        let filter = MPFilter.init()
        
        let buildingId = ProcessInfo.processInfo.environment["building"] ?? "586ca9f1bc1f5702406442b6"
        
        filter.locations = [buildingId]
        
        weak var _self = self
        
        locationService.getLocationsUsing(query, filter: filter) { (locations, error) in
            if let firstLocation = locations?.first {
                _self?.mapControl?.go(to: firstLocation)
            }
        }
    }
}
