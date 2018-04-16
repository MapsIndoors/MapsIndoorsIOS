//
//  CustomFloorSelectorController.swift
//  Demos
//
//  Created by Michael Bech Hansen on 12/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class CustomFloorSelectorController: BaseMapDemoController, MPFloorSelectorProtocol, MPMapControlDelegate {

    private var customFloorSelector : UIBarButtonItem?
    private var currentFloor : NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Floor", style: .plain, target: self, action: #selector(self.activateFloorSelector(sender:)))
        mapControl?.customFloorSelector = self
        mapControl?.delegate = self
        currentFloor = 0
        
        updateTitle()
    }

    @objc
    func activateFloorSelector(sender: UIBarButtonItem) {
        
        if currentBuilding == nil {
            
            let alertController = UIAlertController(title: "Select Floor", message: "No current building.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction( cancel )
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "Select Floor", message: currentBuilding?.name, preferredStyle: .alert)

            let floors : [MPFloor]? = currentBuilding?.getFloorArray()
            if floors != nil {
                for f in floors!.reversed() {
                    let floorName = f.name != nil ? f.name! : "\(f.zIndex!)"
                    let currentFloorIndicator = (currentFloor != nil) && (currentFloor! == f.zIndex) ? "*" : ""
                    let action = UIAlertAction(title: "Floor \(floorName) \(currentFloorIndicator)", style: .default) { (action) in
                        self.setFloor(f.zIndex!)
                        self.mapControl?.currentFloor = f.zIndex!
                    }
                    alertController.addAction( action )
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction( cancel )
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateTitle() {
        
        if let b = currentBuilding {
            let floorName = currentFloor == nil ? "" : " - Floor \(currentFloor!)"
            navigationItem.title = "\(b.name!)\(floorName)"
        } else {
            navigationItem.title = "Custom Floor Selector Demo"
        }
    }
    
    
    // MARK: MPMapControlDelegate
    
    func floorDidChange(_ floor: NSNumber!) {
        
        currentFloor = floor
        updateTitle()
    }
    
    
    // MARK: MPFloorSelectorProtocol
    
    var delegate: MPFloorSelectorDelegate!
    private var currentBuilding : MPBuilding?
    
    func setFloor(_ floor: NSNumber!) {
        self.delegate.floorHasChanged(floor)
    }
    
    func updateFloors(_ building: MPBuilding!) {
        let currentBuildingId = currentBuilding?.buildingId
        let newBuildingId = building != nil ? building.buildingId : nil
        
        if currentBuildingId != newBuildingId {
            currentBuilding = building
            if currentFloor == nil {
                currentFloor = currentBuilding?.getFloor()?.zIndex
            }
            updateTitle()
        }
    }
    
    func deactivate() {
        navigationItem.rightBarButtonItem = nil
    }
}
