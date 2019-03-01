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
 title: Work with location grouping / clustering
 ---
 
 This is an example of enabling and disabling location grouping on the map as well as providing custom cluster tapping behavior and custom cluster images.
 
 Start by creating a `UIViewController` class that conforms to the `MPMapControlDelegate` protocol
 ***/
class ClusteringController: UIViewController, MPMapControlDelegate {
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     Also define a clustering enabling/disabling button and a dictionary to store the clustering images for reuse
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    let clusteringButton = UIButton.init()
    var clusteringImageDictionary = Dictionary<String, UIImage>()
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /***
         Setup map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        self.mapControl?.delegate = self
        
        /***
         Setup a button that enables/disables the location grouping / clustering mechanism
         ***/
        clusteringButton.setTitle("Clustering disabled", for: .normal)
        clusteringButton.setTitle("Clustering enabled", for: .selected)
        clusteringButton.addTarget(self, action: #selector(toggleClustering), for: .touchUpInside)
        clusteringButton.backgroundColor = UIColor.blue
        
        /***
         Arrange the map view and the button in a stackview
         ***/
        let stackView = UIStackView.init(arrangedSubviews: [map!, clusteringButton])
        stackView.axis = .vertical
        view = stackView
        //
    }
    
    /***
     Define an objective-c method `toggleClustering` that will receive events from your button, and toggle the clustering flag:
     
     * Check current state
     * Swap state
     * Make button reflect the state
     ***/
    @objc func toggleClustering() {
        if MPMapControl.locationClusteringEnabled {
            MPMapControl.locationClusteringEnabled = false
        } else {
            MPMapControl.locationClusteringEnabled = true
        }
        clusteringButton.isSelected = MPMapControl.locationClusteringEnabled
    }
    
    /***
     Define the delegate method `didTap` that will receive tap events from a cluster marker
     
     * Check if zoom is possible and increment map zoom
     * Return true to indicate that you handle the event and do not want default behavior to happen
     ***/
    func didTap(_ marker: GMSMarker, forPoiGroup locations: [MPLocation]?, moreZoomPossible: Bool) -> Bool {
        if moreZoomPossible {
            self.map?.animate(toZoom: self.map!.camera.zoom + 1)
        }
        return true
    }
    
    /***
     Define the delegate method `getImageSizeForPoiGroup` that provides the size of the potential cluster
     
     * Check if zoom is possible and increment map zoom
     * Return true to indicate that you handle the event and do not want default behavior to happen
     ***/
    func getImageSizeForPoiGroup(withCount count: UInt, clusterId: String) -> CGSize {
        let width = 48 * (Int(log10(Double(count))) + 1)
        let height = 48
        return CGSize.init(width: width, height: height)
    }
    
    /***
     Define the delegate method `getImageForPoiGroup` that asynchronously provides the image of the potential cluster
     ***/
    func getImageForPoiGroup(_ poiGroup: [MPLocation], imageSize: CGSize, clusterId: String, completion: @escaping (UIImage?) -> Void) -> Bool {
        /***
         In `getImageForPoiGroup` create a string hash for the image
         ***/
        let imgHash = "img\(poiGroup.count)\(clusterId)"
        /***
         In `getImageForPoiGroup` check if image already exists. If image does not exist, go in a background thread to get a dummy image and call the completion handler. Return true to indicate that you handle the clustering image.
         ***/
        var img = clusteringImageDictionary[imgHash]
        if img == nil {
            DispatchQueue.global().async {
                let imgUrlString = "https://placem.at/people?txt=\(poiGroup.count)&random=\(Int.random(in: 0 ..< 10))&w=\(imageSize.width*2)&h=\(imageSize.height*2)"
                let imgUrl = URL(string: imgUrlString)
                do {
                    let imgData = try Data.init(contentsOf: imgUrl!)
                    img = UIImage(data: imgData, scale: 2)
                    completion(img)
                    self.clusteringImageDictionary[imgHash] = img
                } catch {
                    completion(nil)
                }
            }
        } else {
            completion(img)
        }
        return true
        //
    }
}
