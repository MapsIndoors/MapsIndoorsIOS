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
    var searchKey = ""
    var position = CLLocationCoordinate2DMake(0, 0)
    
    convenience init(_ apiKey:String, _ venueKey:String, _ searchKey:String, _ position:CLLocationCoordinate2D) {
        self.init(nibName:nil, bundle:nil)
        MapsIndoors.provideAPIKey(apiKey, googleAPIKey: AppDelegate.gApiKey)
        self.venueKey = venueKey
        self.position = position
        self.searchKey = searchKey
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        
        self.map?.camera = .camera(withLatitude: self.position.latitude, longitude: self.position.longitude, zoom: 17)
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        self.mapControl?.delegate = self
        let q = MPLocationQuery.init()
        q.query = searchKey
        q.venue = self.venueKey
        MPLocationsProvider.init().getLocationsUsing(q) { (data, err) in
            self.mapControl?.searchResult = data?.list
            self.mapControl?.currentFloor = data?.list?.first?.floor
        }
        
        
    }
    
    func mapContentReady() {
        //self.mapControl?.venue = venueKey
    }
}
