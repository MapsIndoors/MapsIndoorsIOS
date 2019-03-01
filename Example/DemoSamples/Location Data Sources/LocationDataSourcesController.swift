//
//  ChangeDisplaySettingController.swift
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
 title: Creating your own Location Source - Part 2
 ---
 
 > Note! This document describes a pre-release feature. We reserve the right to change this feature and the corresponding interfaces without further notice. Any mentioned SDK versions are not intended for production use.
 
 This is part 2 of the tutorial of building a custom Location Source, representing locations of people. [In Part 1 we created the Location Source](locationdatasourcespeoplelocationdatasource). Now we will create a view controller displaying a map that shows the mocked people locations on top of a MapsIndoors map.
 
 Create a class `LocationDataSourcesController` that inherits from `UIViewController`.
 ***/


class LocationDataSourcesController: UIViewController {
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         Inside `viewDidLoad`, register the `PeopleLocationsDataSource` and `MapsIndoorsLocationSource`
         ***/
        MapsIndoors.register([
            MPMapsIndoorsLocationSource.init(),
            PeopleLocationsDataSource.init(type: "People")
        ])
        
        /***
         Inside `viewDidLoad`, setup the map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        /***
         Inside `viewDidLoad`, setup a display setting that refers to the type of locations that your location source operates with.
         ***/
        let dr = MPLocationDisplayRule.init(name: "People", andIcon: UIImage.init(named: "man.png"), andZoomLevelOn: 17)!
        self.mapControl?.add(dr)
    }
    
    /***
     Optionally, when you leave this controller. Remove the custom Location Source by adding back the `MPMapsIndoorsLocationSource` as the only one.
     ***/
    override func viewDidDisappear(_ animated: Bool) {
        MapsIndoors.register([MPMapsIndoorsLocationSource()])
    }
    //
}

