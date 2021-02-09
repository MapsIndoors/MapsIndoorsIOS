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

class ShowLocationController: UIViewController {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*** Show map ***/
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        let locationService = MPLocationService.sharedInstance()
        let query = MPQuery.init()
        let filter = MPFilter.init()
        
        query.query = "Paris"
        filter.take = 1
        
        weak var _self = self
        
        locationService.getLocationsUsing(query, filter: filter) { (locations, error) in
            if error == nil {
                let firstLocation = locations?.first
                _self?.mapControl?.selectedLocation = firstLocation
                _self?.mapControl?.currentFloor = firstLocation?.floor
            }
        }
    }
}
