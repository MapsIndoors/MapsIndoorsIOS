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
        
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        let venueProvider = MPVenueProvider.init()
        
        weak var _self = self
        
        venueProvider.getBuildingsWithCompletion { (buildings, error) in
            if error == nil {
                let bounds = buildings?.first?.getBounds()
                _self?.map?.animate(with: GMSCameraUpdate.fit(bounds!))
            }
        }
    }
}
