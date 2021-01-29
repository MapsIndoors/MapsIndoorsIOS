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
        
        let locations = MPLocationsProvider.init()
        let queryObj = MPLocationQuery.init()
        
        queryObj.query = "Paris"
        queryObj.max = 1
        
        weak var _self = self
        
        locations.getLocationsUsing(queryObj) { (locationData, error) in
            if error == nil {
                let firstLocation = locationData?.list?.first
                _self?.mapControl?.selectedLocation = firstLocation
                _self?.mapControl?.currentFloor = firstLocation?.floor
            }
        }
    }
}
