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

/***
 ---
 title: Show the Blue Dot with MapsIndoors - Part 2
 ---
 
 This is part 2 of the tutorial of managing a blue dot on the map. [In Part 1 we created the position provider](showmylocationmypositionprovider). Now we will create a view controller displaying a map that shows the users (mock) location.
 
 Create a class `ShowMyLocationController` that inherits from `UIViewController`.
 ***/
class ShowMyLocationController: UIViewController {
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         Inside `viewDidLoad`, setup the map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        /***
         Inside `viewDidLoad`, optionally add a special icon for the user location
         ***/
        let myLocationRule = MPLocationDisplayRule.init(name: "my-location", andIcon: UIImage.init(named: "MyLocationDirection"), andZoomLevelOn: 0)
        myLocationRule?.iconSize = CGSize(width: 30, height: 30)
        self.mapControl?.setDisplayRule (myLocationRule!)
        
        /***
         Inside `viewDidLoad`, finally
         
         * Tell mapControl to show the users location
         * Assign your position provider `MyPositionProvider` to `MapsIndoors.positionProvider`
         * Start positioning
         ***/
        self.mapControl?.showUserPosition(true)
        MapsIndoors.positionProvider = MyPositionProvider()
        MapsIndoors.positionProvider?.startPositioning(nil)
        //

    }
}
