//
//  CustomInfoWindowController.swift
//  Demos
//
//  Created by Daniel Nielsen on 12/03/2019.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class CustomInfoWindowController: UIViewController, GMSMapViewDelegate {

    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /***
         Setup map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.delegate = self
        self.mapControl = MPMapControl.init(map: self.map!)
        
        self.title = "Tap on the map!"
        
        self.view = self.map
        
        MPVenueProvider().getVenuesWithCompletion { (coll, err) in
            let venues:[MPVenue] = coll!.venues as! [MPVenue]
            let bounds = venues.first!.getBoundingBox()
            self.map?.animate(with: GMSCameraUpdate.fit(bounds!))
        }
        
    }
    
    /***
     Override the `markerInfoWindow` method to customise the info window
     ***/
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let location = self.mapControl?.getLocation(marker)
        if let locationName = location?.name {
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 280, height: 40))
            label.textColor = UIColor.white
            label.text = "My Custom Info Window for \(locationName)"
            label.textAlignment = .center
            label.backgroundColor = UIColor.red
            return label
        }
        return nil
    }
    
}
