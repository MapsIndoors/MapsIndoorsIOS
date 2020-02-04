//
//  LocationSourcesController.swift
//  SimpleMapSwift
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors

/***
 ---
 title: Creating your own Location Sources - Part 3
 ---
 
 This is part 3 of the tutorial of building custom Location Sources. In [Part 1](locationsourcespeoplelocationsource) and [2 we created the Location Sources](roomavailabilitysource). Now we will create a view controller displaying a map that shows the mocked people locations and the mocked room availability on top of a MapsIndoors map.
 
 Create a class `LocationSourcesController` that inherits from `UIViewController`.
 ***/


class LocationSourcesController: UIViewController {
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         Inside `viewDidLoad`, register the sources `PeopleLocationSource` and `RoomAvailabilitySource`
         ***/
        MapsIndoors.register([
            PeopleLocationSource.init(type: "People"),
            RoomAvailabilitySource.init()
        ])
        
        /***
         Inside `viewDidLoad`, setup the map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        /***
         Inside `viewDidLoad`, setup a display setting that refers to the type of locations that your people location source operates with.
         ***/
        let dr = MPLocationDisplayRule.init(name: "People", andIcon: UIImage.init(named: "user.png"), andZoomLevelOn: 17)!
        dr.displayRank = 99999
        self.mapControl?.setDisplayRule(dr)
    }
    
    /***
     Optionally, when you leave this controller. Remove the custom Location Source by adding back the `MPMapsIndoorsLocationSource` as the only one.
     ***/
    override func viewDidDisappear(_ animated: Bool) {
        MapsIndoors.register([MPMapsIndoorsLocationSource()])
    }
    //
}

