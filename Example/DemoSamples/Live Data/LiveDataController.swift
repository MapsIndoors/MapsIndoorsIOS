//
//  LocationSourcesController.swift
//  SimpleMapSwift
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors
import MapsIndoorsUtils

/***
 ---
 title: Working with Live Updates / Real Time Data in MapsIndoors
 ---
 
 In this tutorial you will learn to work with Live Updates / Real Time Data in MapsIndoors. It is recommended that you read the [Live Data Introduction](../../introductions/live-data) before continueing.
 
 We will create a view controller displaying a map that shows the some dynamic changes that are initiated from Live Data sources known by MapsIndoors. The test data coming as Live Updates contains data for the Occupancy Domain Type and the Position Domain Type.
 
 Create a class `LiveDataController` that inherits from `UIViewController`.
 ***/

class LiveDataController: UIViewController {
    
    /***
    Add buttons for toggling subscriptions, one button for Live Position Updates and one for Live Occupancy Updates.
    ***/
    let positionButton = UIButton.init()
    let occupancyButton = UIButton.init()
    
    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    /***
    Add a `MPLiveDataManager` to the class, being the shared instance. The property is declared `lazy` in order to only instantiate the shared instance once it is needed.
    ***/
    lazy var liveManager = MPLiveDataManager.sharedInstance()
    
    /***
    Add a method `setupSubscriptionButtons()` setting up buttons that enables/disables the subscriptions.
    ***/
    fileprivate func setupSubscriptionButtons() {
        positionButton.setTitle("See Live Positions", for: .normal)
        positionButton.setTitle("Tracking Live Positions", for: .selected)
        positionButton.addTarget(self, action: #selector(togglePosition), for: .touchUpInside)
        positionButton.backgroundColor = UIColor.blue
        
        occupancyButton.setTitle("See Live Occupancy", for: .normal)
        occupancyButton.setTitle("Showing Live Occupancy", for: .selected)
        occupancyButton.addTarget(self, action: #selector(toggleOccupancy), for: .touchUpInside)
        occupancyButton.backgroundColor = UIColor.red
    }
    
    /***
    Add a method `toggleSubscription()` that does the actual toggling of a subscription for a button based on the buttons `isSelected` flag. Swap current selected state for button. If the flag is true and the button is selected, call the Live Data Manager's `subscribe()` method with the given Topic Criteria. We will also call a `startFlash()`method that should make the button flash. More on this later. If the flag is false and the button is not selected, call the Live Data Manager's `unsubscribe()` method with the given Topic Criteria. Similarly we will call a `stopFlash()`method that should stop the button flash.
    ***/
    fileprivate func toggleSubscription(_ button: UIButton, _ topic: MPLiveTopicCriteria) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            liveManager.subscribe(topic)
            button.startFlash()
        } else {
            liveManager.unsubscribe(topic)
            button.stopFlash()
        }
    }
    
    /***
     Define an objective-c method `togglePosition()` that will receive events from your `positionButton`. In this method create a `position` Topic Criteria and call `togglePosition` with the button and the Topic Criteria.
     ***/
    @objc func togglePosition(button:UIButton) {
        let topic = MPLiveTopicCriteria.domainType(MPLiveDomainType.position)
        toggleSubscription(button, topic)
    }
    
    /***
     Define an objective-c method `toggleOccupancy()` that will receive events from your `occupancyButton`. In this method create a `occupancy` Topic Criteria and call `togglePosition` with the button and the Topic Criteria.
     ***/
    @objc func toggleOccupancy(button:UIButton) {
        let topic = MPLiveTopicCriteria.domainType(MPLiveDomainType.occupancy)
        toggleSubscription(button, topic)
    }
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MapsIndoors.provideAPIKey("0e5259aa94704b8890c36ea9", googleAPIKey: nil)
                
        /***
         Inside `viewDidLoad()`, initialise your instance of `GMSMapView` and `MPMapControl`. Set the delegate to be able to get notified about Live Updates for the map.
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.map?.accessibilityElementsHidden = false
        self.mapControl = MPMapControl.init(map: self.map!)
        self.mapControl?.delegate = self as MPMapControlDelegate
        
        /***
        Inside `viewDidLoad()`, also request a building and go to this building on the map.
        ***/
        let q = MPQuery.init()
        let f = MPFilter.init()
        q.query = "020 - Unknown"
        
        MPLocationService.sharedInstance().getLocationsUsing(q, filter: f) { (locations, error) in
            if let loc = locations?.first {
                self.mapControl?.go(to: loc)
            }
        }
        
        /***
         Inside `viewDidLoad()` method, call `setupSubscriptionButtons()` arrange the map view and the buttons in stackviews.
         ***/
        setupSubscriptionButtons()
        let buttonStackView = UIStackView.init(arrangedSubviews: [positionButton, occupancyButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        let stackView = UIStackView.init(arrangedSubviews: [map!, buttonStackView])
        stackView.axis = .vertical
        view = stackView
        
    }
    
    /***
     Optionally, when you leave this controller, unsubscribe all Live Update Topics.
     ***/
    override func viewDidDisappear(_ animated: Bool) {
        liveManager.unsubscribeAll()
    }
    //
}

/***
Create an extension for `LiveDataController` to make it adopt the `MPMapControlDelegate` protocol.
***/
extension LiveDataController : MPMapControlDelegate {
    
    /***
    In the `LiveDataController` extension, add the method `handleLiveUpdate()` that handles a Live Update for a `MPLocation`. This method should only handle the `occupancy` Domain Type, so the first thing is to check for an `occupied` value in the `occupancy` Domain Type. After this verification, do the following:
     
     1. If `occupied == "True"` create the "closed" image, else create the "open" image.
     1. Setup a Location Display Rule with that image.
     1. Check for a `nrOfPeople`value in the same Domain Type.
     1. If present use the value in the label for the Location.
     1. Assign the new Display Rule to the Location through `MPMapControl`.
    ***/
    private func handleLiveUpdate(_ location: MPLocation) {
        let domainType = MPLiveDomainType.occupancy
        if let occupied = location.getLiveValue(forKey:"occupied", domainType: domainType) {
            var img:UIImage?
            var label:String
            if occupied == "True" {
                img = UIImage.init(named: "closed.png")
                label = "\(location.name ?? "") - Occupied"
            } else {
                img = UIImage.init(named: "open.png")
                label = "\(location.name ?? "") - Free"
            }
            guard let icon = img else {
                return
            }
            DispatchQueue.global(qos: .background).async {
                let dr = MPLocationDisplayRule.init(name: domainType, andIcon: icon, andZoomLevelOn: 15)!
                dr.iconSize = CGSize.init(width: 42, height: 42)
                dr.label = label
                dr.showLabel = true
                if let peopleCount = location.getLiveValue(forKey:"nrOfPeople", domainType: domainType) {
                    if peopleCount != "0" {
                        let badgeConfig = BagdedIconConfiguration(originalIcon:icon, badgeText:peopleCount)
                        let badged = BagdedIcon.bagdedIcon(config: badgeConfig)
                        dr.icon = badged
                    }
                }
                DispatchQueue.main.async {
                    self.mapControl?.setDisplayRule(dr, for: location)
                }
            }
        }
    }
    
    /***
    In the `LiveDataController` extension, add the method `willUpdateLocations()`. This is the actual delegate method that recieves all `MPLocation` objects that was updated on the map. Iterate through these locations and skip the ones that have the `position` Domain Type. Call the `handleLiveUpdate()` method for all others.
    ***/
    func willUpdateLocationsOnMap(locations: [MPLocation]) {
        for loc in locations {
            let positionUpdate = loc.getLiveUpdate(forDomainType: MPLiveDomainType.position)
            if positionUpdate == nil {
                handleLiveUpdate(loc)
            }
        }
    }
    
}

/***
Earlier we called some non-existing methods, `startFlash()` and `stopFlash()` on a `UIButton`. We will create these methods now. Create an extension for `UIButton`.
***/
extension UIButton {
    
    /***
    In the `UIButton` extension, add the method `startFlash()` that creates and adds an animation layer that manipulates with the opacity of the button over time.
    ***/
    func startFlash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .greatestFiniteMagnitude
        layer.add(flash, forKey: "flash")
    }
    
    /***
    In the `UIButton` extension, add the method `stopFlash()` that removes the above layer again.
    ***/
    func stopFlash() {
        layer.removeAnimation(forKey: "flash")
    }
    //
}
