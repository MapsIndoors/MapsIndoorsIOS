//
//  ChangeDisplaySettingController.swift
//  SimpleMapSwift
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors

class ChangeDisplaySettingController: UIViewController {
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.view = self.map
        self.map?.camera = .camera(withLatitude: 57.057964, longitude: 9.9504112, zoom: 20)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        let displayRule = MPLocationDisplayRule.init(name: "MeetingRoom", andIcon: UIImage.init(named: "kitten.jpg"), andZoomLevelOn: 16)
        displayRule?.iconSize = CGSize.init(width: 30, height: 30)
        
        self.mapControl?.add(displayRule!)
        
        let deadlineTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let displayRule = MPLocationDisplayRule.init(name: "MeetingRoom", andIcon: UIImage.init(named: "kitten2.jpg"), andZoomLevelOn: 16)
            displayRule?.iconSize = CGSize.init(width: 30, height: 30)
            self.mapControl?.add(displayRule!)
        }
        
    }
}
