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

/***
 ---
 title: Show Location Details
 ---
 
 This is an example of displaying some details of a MapsIndoors location
 
 Start by creating a `UIViewController` class that conforms to the `GMSMapViewDelegate` protocol
 ***/
class LocationDetailsController: UIViewController, GMSMapViewDelegate { 
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    var selectedLocation:MPLocation? = nil
    
    /***
     Add other views needed for this example
     ***/
    var detailsView:UITableView = UITableView.init()
    var mainView:UIStackView = UIStackView.init()
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         Inside `viewDidLoad`, setup the map and the mapControl instance
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.delegate = self
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        /***
         Setup the table view
         ***/
        self.detailsView.dataSource = self as UITableViewDataSource

        /***
         Arrange the map and the stackview inside another stackview
         ***/
        mainView = UIStackView.init(arrangedSubviews: [map!, detailsView])
        mainView.axis = .vertical
        //
        
        self.detailsView.translatesAutoresizingMaskIntoConstraints = false
        self.detailsView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        self.detailsView.widthAnchor.constraint(equalTo: self.mainView.widthAnchor).isActive = true
        
        view = mainView
        
    }
    
    /***
     When marker is tapped, get related MapsIndoors location object and set label text, based on the name and description of the location
     ***/
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectedLocation = mapControl?.getLocation(marker)
        detailsView.reloadData()
        return false
    }
    
    /***
     When map is tapped, reset label text
     ***/
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
    //
}

extension LocationDetailsController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value2, reuseIdentifier: nil)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = selectedLocation?.name
        case 1:
            cell.textLabel?.text = "Room Id"
            cell.detailTextLabel?.text = selectedLocation?.externalId
        case 2:
            cell.textLabel?.text = "Floor Index"
            cell.detailTextLabel?.text = selectedLocation?.floor?.stringValue
        default:
            break
        }
        
        return cell
    }
    
    
}
