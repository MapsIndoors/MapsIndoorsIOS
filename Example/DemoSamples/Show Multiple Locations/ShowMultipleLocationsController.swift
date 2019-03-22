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

class ShowMultipleLocationsController: UIViewController {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*** Show map ***/
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 17)
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        /*** Show search on map ***/
        
        let locations = MPLocationsProvider.init()
        let queryObj = MPLocationQuery.init()
        
        queryObj.categories = ["Toilet"]
        
        locations.getLocationsUsing(queryObj) { (locationData, error) in
            if error == nil {
                self.mapControl?.searchResult = locationData!.list
                //self.mapControl?.showSearchResult(true)
                let firstLocation = locationData?.list?.first
                self.mapControl?.currentFloor = firstLocation?.floor         // You are not guaranteed that the visible floor contains any search results, so that is why we change floor
            }
        }
    }
}
