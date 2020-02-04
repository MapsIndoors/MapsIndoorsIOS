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
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        self.mapControl?.delegate = self
        let q = MPQuery.init()
        q.query = venueKey
        let f = MPFilter.init()
        
        weak var _self = self
        
        MPLocationService.sharedInstance().getLocationsUsing(q, filter: f) { (locations, err) in
            if let location = locations?.first {
                _self?.mapControl?.selectedLocation = location
                _self?.mapControl?.go(to: location)
            }
        }
        
//        let deadlineTime = DispatchTime.now() + .seconds(5)
//
//        // Test that previous dataset is properly deleted from memory
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//            UIApplication.shared.perform(Selector(("_performMemoryWarning")))
//        }
    }
    
//    func mapContentReady() {
//        self.mapControl?.venue = venueKey
//    }
}
