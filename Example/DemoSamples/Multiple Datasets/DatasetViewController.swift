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

class DatasetViewController: UIViewController, MPMapControlDelegate {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    var venueKey = ""
    
    convenience init(_ apiKey:String, _ venueKey:String) {
        self.init(nibName:nil, bundle:nil)
        MapsIndoors.provideAPIKey(apiKey, googleAPIKey: AppDelegate.gApiKey)
        self.venueKey = venueKey
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        
        self.mapControl = MPMapControl.init(map: self.map)
        
        self.mapControl?.delegate = self
        
        
    }
    
    func mapContentReady() {
        self.mapControl?.venue = venueKey
    }
}
