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

class DatasetMapController: UIViewController, MPMapControlDelegate {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    convenience init(_ apiKey:String) {
        self.init(nibName:nil, bundle:nil)
        MapsIndoors.provideAPIKey(apiKey, googleAPIKey: AppDelegate.gApiKey)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        self.mapControl?.delegate = self
        let q = MPQuery.init()
        let f = MPFilter.init()
        f.categories = ["venue"]
        
        weak var _self = self

        MPLocationService.sharedInstance().getLocationsUsing(q, filter: f) { (locations, err) in
            if let location = locations?.first {
                _self?.mapControl?.selectedLocation = location
                _self?.mapControl?.go(to: location)
            }
        }
    }
}
