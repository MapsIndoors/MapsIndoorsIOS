//
//  ShowRouteOnMapController
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors


/***
 ---
 title: Get Directions and Show the Result on a Map - Part 1
 ---
 
 In this tutorial we will request a route, list the route parts and render these on a Google Map. A MapsIndoors route is made of one or more legs, each containing one or more steps.
 
 We will start by making the controller that renders the route from the input of a route, a leg index and optionally a step index. Start by creating a `UIViewController` implementation that conforms to `MPDirectionsRendererDelegate`
 ***/
class ShowRouteOnMapController: UIViewController, MPDirectionsRendererDelegate {
    
    /***
     Setup member variables for `MySearchController`:
     
     * An instance of type `GMSMapView`
     * An instance of type `MPMapControl`
     * An instance of type `MPRoute` (the route object)
     * A leg index
     * A step index
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    var route:MPRoute? = nil
    var leg:Int = -1
    var step:Int = -1
    
    /***
     Create an initializer for your input parameters
     ***/
    convenience init(_ route:MPRoute, _ leg:Int, _ step:Int) {
        self.init(nibName:nil, bundle:nil)
        self.route = route
        self.leg = leg
        self.step = step
    }
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()

        /***
         Setup the Google map and your `MPMapControl` instance
        ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        //

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        /***
         Inside `viewDidAppear`, setup a directions renderer and assign the Google map, route object and leg/step indices. Eventually, call the animate method to make it animate from the start to end of the leg/step
         ***/
        let renderer = MPDirectionsRenderer.init()
        
        renderer.delegate = self
        renderer.fitBounds = true
        
        renderer.map = self.map
        renderer.route = route
        
        renderer.routeLegIndex = leg
        renderer.routeStepIndex = step
        renderer.animate(5)
    }
    
    /***
     In the `floorDidChange` delegate method change the floor on your `MPMapControl instance`
     ***/
    func floorDidChange(_ floor: NSNumber) {
        mapControl?.currentFloor = floor
    }
    //
}

/*** In [Part 2](searchsearchmapcontroller) we will create the map view controller that displays the blue dot. ***/
