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
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        let directions = MPDirectionsService.init()
        let renderer = MPDirectionsRenderer.init()
        renderer.delegate = self
        
        let origin = MPPoint.init(lat: 57.057917, lon: 9.950361, zValue:0)
        let destination = MPPoint.init(lat: 57.058038, lon: 9.950509, zValue:0)
        
        let directionsQuery = MPDirectionsQuery.init(originPoint: origin!, destination: destination!)
        
        directions.routing(with: directionsQuery) { (route, error) in
            
            if let legs = route!.legs {
                
                for legIndex in 0 ..< legs.count {
                    let deadlineTime = DispatchTime.now() + .seconds(legIndex*5)
                    renderer.map = self.map
                    renderer.route = route
                    
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        renderer.routeLegIndex = legIndex
                        renderer.animate(5)
                    }
                }
            }
        }
    }
}
