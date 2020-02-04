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
        
        let venueProvider = MPVenueProvider.init()

        weak var _self = self
        
        venueProvider.getVenuesWithCompletion { (venueColl, error) in
            if error == nil {
                let bounds = (venueColl!.venues!.first as! MPVenue).getBoundingBox()
                _self?.map?.animate(with: GMSCameraUpdate.fit(bounds!))
            }
        }
    }
}
