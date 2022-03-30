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

class ShowVenueController: UIViewController, MPMapControlDelegate {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
                
        self.view = self.map
        
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        let locationService = MPLocationService.sharedInstance()
        let query = MPQuery.init()
        let filter = MPFilter.init()
        
        let buildingId = ProcessInfo.processInfo.environment["venue"] ?? "586ca9f1bc1f5702406442b6"
        
        filter.locations = [buildingId]
        
        weak var _self = self
        
        locationService.getLocationsUsing(query, filter: filter) { (locations, error) in
            if let firstLocation = locations?.first {
                _self?.mapControl?.go(to: firstLocation)
            }
        }
    }
}
