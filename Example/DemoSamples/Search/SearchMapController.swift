//
//  SearchController.swift
//  Demos
//
//  Created by Daniel Nielsen on 15/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors

/**
 ---
 title: Create a Search Experience with MapsIndoors - Part 2
 ---

 This is part 2 of the tutorial of creating a simple search experience using MapsIndoors. [In Part 1 we created the search controller](searchmysearchcontroller). Now we will create the "main" controller displaying the map and eventually the selected location.
 
 Create a view controller class that inherits from `UIViewController` and conforms to the `MySearchControllerDelegate` protocol
 **/
class SearchMapController: UIViewController, MySearchControllerDelegate, GMSMapViewDelegate {
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    var center: MPPoint = MPPoint.init(lat: 0, lon: 0)
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         Setup map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.delegate = self
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        /***
         Setup a button that targets a method (`openSearch`) in your class
         ***/
        let button = UIButton.init()
        button.setTitle("Search", for: .normal)
        button.addTarget(self, action: #selector(openSearch), for: .allTouchEvents)
        button.backgroundColor = UIColor.blue
        
        /***
         Arrange the map view and the button in a stackview
         ***/
        let stackView = UIStackView.init(arrangedSubviews: [map!, button])
        stackView.axis = .vertical
        view = stackView
        //
    }

    /***
     Define an objective-c method `openSearch` that will receive events from your button, and handle them:
     
     * Initialise `MySearchController`
     * Assign self as delegate
     * Present the new view controller
     ***/
    @objc func openSearch() {
        let searchController = MySearchController.init(near:self.center)
        searchController.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }

    /***
     Implement the method `didSelectLocation` required from `MySearchControllerDelegate` delegate. In this example we will just go to the selected location in the map.
     ***/
    func didSelectLocation(location: MPLocation) {
        mapControl?.go(to: location)
        mapControl?.selectedLocation = location
    }
    //
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.center = MPPoint.init(lat: position.target.latitude, lon: position.target.longitude)
    }
}
