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
 title: Working with Live Data in MapsIndoors
 ---
 
 In this tutorial you will learn to work with Live Data / Real Time Data in MapsIndoors. It is recommended that you read the [Live Data Introduction](../../introductions/live-data) before continueing.
 
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
    Add a method `setupLiveDataButtons()` setting up buttons that enables/disables the subscriptions.
    ***/
    fileprivate func setupLiveDataButtons() {
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
    Add a method `toggleLiveData()` that does the actual toggling of Live Data for a button based on the buttons `isSelected` flag. Swap current selected state for button. If the flag is true and the button is selected, call the `MPMapControl.enableLiveData()` method with the given Domain Type. We will also call a `startFlash()`method that should make the button flash. More on this later. If the flag is false and the button is not selected, call the `MPMapControl.disableLiveData()` method with the given Domain Type. Similarly we will call a `stopFlash()`method that should stop the button flash. In this example, we choose to have a customized rendering of Live Data, so we provide a Handler instance that gets the updated Locations. We will get to that later.
    ***/
    fileprivate func toggleLiveData(_ button: UIButton, _ domainType: String) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            mapControl?.enableLiveData(domainType, handler: self)
            button.startFlash()
        } else {
            mapControl?.disableLiveData(domainType)
            button.stopFlash()
        }
    }
    
    /***
     Define an objective-c method `togglePosition()` that will receive events from your `positionButton`. In this method create a `position` Topic Criteria and call `togglePosition` with the button and the Topic Criteria.
     ***/
    @objc func togglePosition(button:UIButton) {
        toggleLiveData(button, MPLiveDomainType.position)
    }
    
    /***
     Define an objective-c method `toggleOccupancy()` that will receive events from your `occupancyButton`. In this method create a `occupancy` Topic Criteria and call `togglePosition` with the button and the Topic Criteria.
     ***/
    @objc func toggleOccupancy(button:UIButton) {
        toggleLiveData(button, MPLiveDomainType.occupancy)
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
        
        /***
        Inside `viewDidLoad()`, also request a building and go to this building on the map.
        ***/
        let q = MPQuery.init()
        let f = MPFilter.init()
        f.locations = ["4036547c2c5741bf9cf2ddae"]
        
        MPLocationService.sharedInstance().getLocationsUsing(q, filter: f) { (locations, error) in
            if let loc = locations?.first {
                self.mapControl?.go(to: loc)
            }
        }
        
        /***
         Inside `viewDidLoad()` method, call `setupLiveDataButtons()` arrange the map view and the buttons in stackviews.
         ***/
        setupLiveDataButtons()
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
        mapControl?.disableLiveData(MPLiveDomainType.position)
        mapControl?.disableLiveData(MPLiveDomainType.occupancy)
    }
    //
}

/***
Create an extension for `LiveDataController` to make it adopt the `MPMappedLocationUpdateHandler` protocol. Note that if you are happy with the default rendering of Live Data, this part is not needed.
***/
extension LiveDataController : MPMappedLocationUpdateHandler {
    
    /***
    In the `LiveDataController` extension, add the method `handleLiveUpdate()` that handles a Live Update for a `MPLocation`. This method should only handle the `occupancy` Domain Type, so the first thing is to check for a `MPLiveUpdate` object for the `occupancy` Domain Type. After this verification, do the following:
     
     1. If `occupancy.numberOfPeople > 0` create the "closed" image, else create the "open" image.
     1. Preferrably in a separate background thread, setup a Location Display Rule with that image.
     1. If `occupancy.numberOfPeople > 0` create a icon badge showing the number of people as text in the badge. How you do this is up to you. In this example we use [this code](https://github.com/MapsIndoors/MapsIndoorsUtils).
     1. Apply the newly created display rule on the main thread.
    ***/
    private func handleLiveUpdate(_ location: MPLocation) {
        let domainType = MPLiveDomainType.occupancy
        if let occupancy = location.getLiveUpdate(forDomainType: domainType) as? MPOccupancyLiveUpdate {
            var img:UIImage?
            var label:String
            if occupancy.numberOfPeople > 0 {
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
                dr.label = label
                dr.showLabel = true
                dr.iconSize = CGSize.init(width: 20, height: 20)
                if occupancy.numberOfPeople > 0 {
                    let badgeConfig = BagdedIconConfiguration(originalIcon:icon, badgeText:"\(occupancy.numberOfPeople)")
                    let badged = BagdedIcon.bagdedIcon(config: badgeConfig)
                    dr.icon = badged
                    dr.iconSize = CGSize.init(width: 28, height: 28)
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
