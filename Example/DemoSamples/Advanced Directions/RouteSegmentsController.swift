//
//  DemosViewController.swift
//  Demos
//
//  Created by Daniel Nielsen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

/***
 ---
 title: Get Directions and Show Wayfinding Instructions - Part 2
 ---
 
 This is part 2 of [the directions tutorial](../advanceddirectionsroutesegmentview) showing you how to work with the route model returned from a directions service call. In this part we will create the controller that displays generated textual instructions segment by segment.
 
 We use a collection view to do this but you can of course use whatever view that fits your use case best.
 
 First we will define a protocol called `RouteSegmentsControllerDelegate` that will be used to handle the selection of each represented route segment. The method `didSelectRouteSegment` will be delegating the handling of route segment selections.
 ***/

protocol RouteSegmentsControllerDelegate {
    func didSelectRouteSegment(segment:MPRouteSegmentPath)
}


/***
 ## The Route Segments Controller
 Create a controller class called `RouteSegmentsController` that inherits from `UIViewController`.
 ***/
class RouteSegmentsController : UIViewController {
    /***
     Add some properties to the controller
     *`startingScrollingOffset` We will do a side-ways scroll in the collection, so we will add a private point property to keep track of that
     *`tableView` the actual table view property.
     *`delegate` the delegate property.
     ***/
    private var startingScrollingOffset = CGPoint.zero
    private var tableView:UITableView!
    var delegate:RouteSegmentsControllerDelegate?
    
    /***
     Add a `route` property to the class
     ***/
    var route:MPRoute = MPRoute() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    /***
     Add a `currentSegment` property to the class
     ***/
    var currentSegment:MPRouteSegmentPath = MPRouteSegmentPath() {
        didSet {
            if oldValue.legIndex != currentSegment.legIndex {
                self.tableView.reloadData()
            }
        }
    }
    
    /***
     Implement `viewDidLoad` method, creating the horizontal collection view and assigning delegates to the collection view. Make sure that you register your own custom `RouteSegmentView` here.
     ***/
    override func viewDidLoad() {
        self.tableView = UITableView.init(frame: view.frame)
//        self.tableView.translatesAutoresizingMaskIntoConstraints = false
//        self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
//        self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
//        self.tableView.topAnchor.constraint(equalTo: view.topAnchor)
//        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        self.tableView.dataSource = self as UITableViewDataSource
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.register(RouteSegmentView.self, forCellReuseIdentifier: "TVC")
        self.tableView.bounces = true
        self.view = self.tableView
    }
    
    /***
     Create a method 'updateRouteSegmentSelection' that notifies the delegate
    ***/
    func updateRouteSegmentSelection(segment: MPRouteSegmentPath) {
        delegate?.didSelectRouteSegment(segment: segment)
        currentSegment = segment
    }
    //
}

/***
 ## The Route Segments Controller Data Source
 Create an extension of `RouteSegmentsController` that implements `UICollectionViewDataSource` protocol.
 ***/
extension RouteSegmentsController : UITableViewDataSource {
    /***
     In the `collectionView numberOfItemsInSection` method, let the item count reflect the number of legs in the current route.
     ***/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let leg = route.legs?[section] as? MPRouteLeg
        return leg?.steps?.count ?? 0
    }
    
    /***
     In the `collectionView cellForItemAt indexPath` method, create a segment based on the index paths row (leg) index. Dequeue a cell view and update the `route` and `segment` properties accordingly.
     ***/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let segment = MPRouteSegmentPath(legIndex: indexPath.section, stepIndex: indexPath.row)
        let tvCell:RouteSegmentView = tableView.dequeueReusableCell(withIdentifier: "TVC", for: indexPath) as! RouteSegmentView
        tvCell.renderRouteInstructions(route, for: segment)
        return tvCell
    }
    
    /***
     In the `titleForHeaderInSection` method, return the number of legs in the current route.
     ***/
    func numberOfSections(in tableView: UITableView) -> Int {
        return route.legs?.count ?? 0
    }
    
    /***
     Implement the `heightForRowAtIndexPath` method.
     ***/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    /***
     Optionally implement the `titleForHeaderInSection` method.
     ***/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let leg = route.legs?[section] as? MPRouteLeg {
            let meters = leg.distance?.intValue ?? 0
            return "\(meters) meters"
        }
        return ""
    }
    //
}

/***
 ## Table View Delegate
 Create an extension of `RouteSegmentsController` that implements `UITableViewDelegate` protocol. In method `didSelectRowAtIndexPath` update the current route segment.
 ***/
extension RouteSegmentsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateRouteSegmentSelection(segment: MPRouteSegmentPath(legIndex: indexPath.section, stepIndex: indexPath.row))
    }
    //
}

/***
 In [the next part we will create a controller](../advanceddirectionsadvanceddirectionscontroller) we will create a controller that renders a map and utilizes interaction between a route rendered on the map and the selected instructions.
 ***/
