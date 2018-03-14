//
//  BaseMapDemoController.swift
//  Demos
//
//  Created by Michael Bech Hansen on 12/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors

class BaseMapDemoController: UIViewController {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*** Show map ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map)
    }
}
