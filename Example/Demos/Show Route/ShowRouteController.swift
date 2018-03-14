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

class ShowRouteController: UIViewController, MPDirectionsRendererDelegate {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*** Show map ***/
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        
        self.mapControl = MPMapControl.init(map: self.map)
        
        /*** Show route on map ***/
        
        let directions = MPDirectionsService.init()
        let renderer = MPDirectionsRenderer.init()
        renderer.delegate = self
        
        let origin = MPPoint.init(lat: 57.057917, lon: 9.950361, zValue:0)
        let destination = MPPoint.init(lat: 57.058038, lon: 9.950509, zValue:0)

        let directionsQuery = MPDirectionsQuery.init(originPoint: origin!, destination: destination!)
        
        directions.routing(with: directionsQuery) { (route, error) in
            renderer.map = self.map
            renderer.route = route
            renderer.routeLegIndex = 0
            renderer.animate(5)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


