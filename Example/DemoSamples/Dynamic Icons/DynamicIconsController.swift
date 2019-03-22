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

class DynamicIconsController: UIViewController, GMSMapViewDelegate {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    var locationsProvider = MPLocationsProvider()
    var locationSet = NSMutableOrderedSet()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.delegate = self
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
            
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        let mapExtend = MPMapExtend.init(gmsBounds: GMSCoordinateBounds.init(region:  mapView.projection.visibleRegion() ) )
        let locationQuery = MPLocationQuery()
        locationQuery.mapExtend = mapExtend
        locationQuery.floor = mapControl?.currentFloor
        locationsProvider.getLocationsUsing(locationQuery) { (locationData, error) in
            
            var count = 0
            
            for loc in locationData!.list! {
                let icon = DynamicIcon.instanceFromNib()
                count += 1
                icon.label.text = "\(count) min"
                loc.displayRule = MPLocationDisplayRule()
                loc.displayRule?.visible = true
                loc.displayRule?.iconSize = icon.bounds.size
                loc.displayRule?.icon = MPImageRenderer.image(with: icon)
                self.locationSet.add(loc)
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for loc:MPLocation in locationSet.array as! [MPLocation] {
            loc.displayRule = nil
        }
    }
}
