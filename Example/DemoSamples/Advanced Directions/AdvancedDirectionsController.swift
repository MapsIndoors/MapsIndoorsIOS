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
 title: Get Directions and Show the Result on a Map - Part 3
 ---
 
 This is part 3 of [the directions tutorial](../advanceddirectionsroutesegmentview) showing you how to work with the route model returned from a directions service call. In this part we will create a controller that renders a map and utilizes interaction between a route rendered on the map and the selected instructions.

 Start by creating a controller class `AdvancedDirectionsController` that inherits from `UIViewController`
 ***/
class AdvancedDirectionsController: UIViewController {
    
    /***
     Setup map-related member variables for `AdvancedDirectionsController`:
     
     * A Google Maps `map` property
     * A MapsIndoors `mapControl` property
     * A MapsIndoors `renderer` property
     * A `routeVC` property used as a child view controller to this VC
     ***/
    var map: GMSMapView! = nil
    var mapControl: MPMapControl! = nil
    var renderer: MPDirectionsRenderer! = nil
    var stepWiseRenderer: MPDirectionsRenderer! = nil
    
    /***
     Setup directions related member variables for `AdvancedDirectionsController`:
     
     * A `routeVC` property used as a child view controller to this VC
     * A `heightConstraintForRouteView` property that can control the visibility of the route view
     * A `directionsVisible` bool that can control the visibility of the route view by affecting the height of the route view
     * A `searchButton` that will open a search controller to choose your destination
     ***/
    var routeVC: RouteSegmentsController! = nil
    var heightConstraintForRouteView:NSLayoutConstraint! = nil
    var directionsVisible:Bool! {
        didSet {
            heightConstraintForRouteView.constant = directionsVisible ? 240 : 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    var searchButton:UIButton! = nil
    let directions = MPDirectionsService.init()
    var destinationLocation:MPLocation? {
        didSet {
            updateDirections()
            searchButton.setTitle(destinationLocation?.name, for: .normal)
        }
    }
    var originLocation:MPLocation?
    
    
    /***
     Create a `setupMap` method that sets up the Google map and MapsIndoors Map Control object.
     ***/
    fileprivate func setupMap() {
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        view.addSubview(self.map)
    }
    
    /***
     Create a `setupSearchButton` method that sets up a button that can trigger the destination location selection.
     ***/
    fileprivate func setupSearchButton() {
        searchButton = UIButton.init()
        searchButton.setTitle("Search Destination", for: .normal)
        searchButton.addTarget(self, action: #selector(selectDestination), for: .touchUpInside)
        searchButton.backgroundColor = .blue
        view.addSubview(searchButton)
    }
    
    /***
     Create a `setupConstraints` method that sets up all the layout constraints. In your projects you might do all this in a storyboard.
     ***/
    fileprivate func setupConstraints() {
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.heightAnchor.constraint(equalToConstant: 68).isActive = true
        searchButton.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        
        routeVC.view.translatesAutoresizingMaskIntoConstraints = false
        routeVC.view.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        routeVC.view.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        routeVC.view.topAnchor.constraint(equalTo:searchButton.bottomAnchor).isActive = true
        
        heightConstraintForRouteView = routeVC.view.heightAnchor.constraint(equalToConstant:0)
        heightConstraintForRouteView.isActive = true
    }
    
    /***
     Create a `setupRouteNav` method that instantiates `RouteSegmentsController` and adds it as a child view controller. Assign this controller as its delegate.
     ***/
    fileprivate func setupRouteNav() {
        routeVC = RouteSegmentsController.init()
        self.addChildViewController(routeVC!)
        view.addSubview(routeVC.view)
        routeVC.didMove(toParentViewController: self)
        routeVC.delegate = self as RouteSegmentsControllerDelegate
    }
    
    /***
     Create a `selectDestination` method that instantiates and presents `MySearchController`. Assign this controller as its delegate.
     ***/
    @objc fileprivate func selectDestination() {
        let searchController = MySearchController.init(near: nil)
        searchController.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    /***
     Create a `setupRenderer` method that instantiates `MPDirectionsRenderer` and adds it as a child view controller. Assign this controller as its delegate.
     ***/
    fileprivate func setupRenderer() {
        self.renderer = MPDirectionsRenderer.init()
        self.renderer.delegate = self as MPDirectionsRendererDelegate
        self.renderer.fitBounds = true
        self.renderer.solidColor = .clear
        self.renderer.map = self.map
        
        self.stepWiseRenderer = MPDirectionsRenderer.init()
        self.stepWiseRenderer.fitBounds = false
        self.stepWiseRenderer.map = self.map
        self.stepWiseRenderer.nextRouteLegButton?.isHidden = true
        self.stepWiseRenderer.previousRouteLegButton?.isHidden = true
    }
    
    /***
     Create a `setOriginLocation` method that mocks a origin location by searching for a random venue in MapsIndoors.
     ***/
    fileprivate func setOriginLocation() {
        let q = MPQuery()
        q.query = "venue"
        MPLocationService.sharedInstance().getLocationsUsing(q, filter: MPFilter()) { (locations, err) in
            if let loc = locations?.first {
                self.originLocation = loc
                self.mapControl.go(to: loc)
            }
        }
    }
    
    /***
     In the `viewDidLoad` put the pieces together by calling the above methods.
     ***/
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupSearchButton()
        setupRouteNav()
        setupRenderer()
        setupConstraints()
        setOriginLocation()
    }
    
    /***
     Create a `updateDirections` method that sets up a MapsIndoors directions query. Execute a query and pass the resulting route object to the renderer.
     ***/
    fileprivate func updateDirections() {
        if let origin = originLocation, let destination = destinationLocation {
            let directionsQuery = MPDirectionsQuery.init(origin: origin, destination: destination)
            directions.routing(with: directionsQuery) { (route, error) in
                if let route = route {
                    self.directionsVisible = true
                    self.routeVC!.route = route
                    self.renderer.route = route
                    self.renderer.routeLegIndex = 0
                    self.stepWiseRenderer.route = route
                }
            }
        }
    }
    //
}

/***
 ## Map interactions
 Let's do a couple of extensions for the map interactions. First implement the `RouteSegmentsControllerDelegate` through an extension. In `didSelectRouteSegment` update the leg index for the directions renderer.
 ***/
extension AdvancedDirectionsController : RouteSegmentsControllerDelegate {
    func didSelectRouteSegment(segment: MPRouteSegmentPath) {
        renderer.routeLegIndex = segment.legIndex
        renderer.fitBounds = false
        stepWiseRenderer.routeLegIndex = segment.legIndex
        stepWiseRenderer.routeStepIndex = segment.stepIndex
        stepWiseRenderer.animate(3)
        stepWiseRenderer.fitBounds = true
    }
}

/***
 Implement the `MPDirectionsRendererDelegate` through an extension. In `floorDidChange` update the current visible floor on the map control object.
 ***/
extension AdvancedDirectionsController : MPDirectionsRendererDelegate {
    func floorDidChange(_ floor: NSNumber) {
        mapControl.currentFloor = floor
    }
}

/***
 Implement the `MySearchControllerDelegate` through an extension. In `didSelectLocation` update the `destinationLocation` property.
 ***/
extension AdvancedDirectionsController : MySearchControllerDelegate {
    func didSelectLocation(location: MPLocation) {
        destinationLocation = location
    }
}
