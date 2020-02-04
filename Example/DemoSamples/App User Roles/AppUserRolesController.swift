//
//  AppUserRolesController.swift
//  Demos
//
//  Created by Daniel Nielsen on 22/08/2019.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors

/**
 ---
 title: Working with App User Roles
 ---
 
 This tutorial shows you how to show routes on a map that are calculated based on a given user role.
 
 Create a view controller class that inherits from `UIViewController`
 **/
class AppUserRolesController: UIViewController {
    
    /***
     Setup some member variables for your controller:
     
     * The map object `GMSMapView`
     * The map control object `MPMapControl`
     * A directions service `MPDirectionsService`
     * A directions renderer `MPDirectionsRenderer`
     * A segmented control view to control and visualise the current selected role
     * An array of user roles
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    let directionsService = MPDirectionsService.init()
    let directionsRenderer = MPDirectionsRenderer.init()
    var userRoleSegmentedControl = UISegmentedControl()
    var userRoles = [MPUserRole]()
    
    /***
     Create a function `getUserRoles` that fetches the app user roles from the MapsIndoors solution. For each of the user roles, insert a segment in the segmented control view.
     ***/
    func getUserRoles() {
        MPSolutionProvider.init().getUserRoles { (userRoles, error) in
            self.userRoles = userRoles!
            self.userRoles.forEach({ (userRole) in
                self.userRoleSegmentedControl.insertSegment(withTitle: "\(userRole.userRoleName) route", at: 0, animated: false)
            })
        }
    }
    
    /***
     Create an objective-c method `startDirections` that will receive events from a segmented control view, retrieve the corresponding user role and perform a route request with that user role configured. On route result, use the directions renderer to render the route on the map.
     ***/
    @objc func startDirections(sender:UISegmentedControl) {
        let index = userRoleSegmentedControl.selectedSegmentIndex
        let userRole = self.userRoles[index]
        let directionsQuery = MPDirectionsQuery.init(originPoint: MPPoint.init(lat: 57.0857756, lon: 9.9576971, zValue: 0), destination: MPPoint.init(lat: 57.0861556, lon: 9.958375, zValue: 0))
        directionsQuery.userRoles = [userRole]
        
        weak var _self = self
        
        directionsService.routing(with: directionsQuery) { (route, error) in
            
            _self?.directionsRenderer.fitBounds = true
            _self?.directionsRenderer.fitMode = .northBound
            _self?.directionsRenderer.route = route
            _self?.directionsRenderer.routeLegIndex = 0
            _self?.directionsRenderer.map = _self?.map
            
        }
    }
    
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         In your `viewDidLoad`, setup map so that it shows the demo venue and initialise mapControl.
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        /***
         In your `viewDidLoad`, setup the `userRoleSegmentedControl` and put both the map and the segmented control view into a vertical stack view. Add an event target for your segmented control.
         ***/
        let stackView = UIStackView.init(arrangedSubviews: [map!, userRoleSegmentedControl])
        stackView.axis = .vertical
        self.view = stackView
        userRoleSegmentedControl.backgroundColor = .white
        userRoleSegmentedControl.addTarget(self, action: #selector(startDirections), for: .valueChanged)
        
        /***
         Lastly, in your `viewDidLoad`, call `getUserRoles`
         ***/
        self.getUserRoles()
        //
    }
    
}
