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
    var selectedMarker : GMSMarker? = nil
    
    /***
     Setup map so that it shows the demo venue and initialise mapControl
     ***/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.delegate = self
        self.mapControl = MPMapControl.init(map: self.map!)
        
        self.title = "Tap on the map!"
        
        self.view = self.map
        
        weak var _self = self
        
        MPVenueProvider().getVenuesWithCompletion { (coll, err) in
            let venues:[MPVenue] = coll!.venues as! [MPVenue]
            let bounds = venues.first!.getBoundingBox()
            _self?.map?.animate(with: GMSCameraUpdate.fit(bounds!))
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
            label.backgroundColor = [UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.magenta, UIColor.yellow][Int.random(in: 0...5)]
            return label
        }
        return nil
    }
    
    /***
     Please note that once a view has been returned in the above method, the Google Map's rendering of that view will not change if you change the view at a later point. If you need to display something dynamic, a workaround is to invoke `markerInfoWindow`again by re-setting the `selectedMarker` on `GMSMapView`. Override the `didTapMarker` method to get a reference to the marker. At a later point when you need the info window to update, set the `selectedMarker` on `GMSMapView` to `nil`and set it back to the original selected marker again.
     ***/
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.selectedMarker = marker
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            
            self.map!.selectedMarker = nil
            self.map!.selectedMarker = self.selectedMarker
            
        }
        return false
    }
    //
}
