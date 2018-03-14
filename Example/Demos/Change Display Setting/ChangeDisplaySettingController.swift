//
//  ChangeDisplaySettingController.swift
//  SimpleMapSwift
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class ChangeDisplaySettingController: BaseMapDemoController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let displayRule = MPLocationDisplayRule.init(name: "MeetingRoom", andIcon: UIImage.init(named: "archive"), andZoomLevelOn: 16)
        displayRule?.iconSize = CGSize.init(width: 42, height: 42)
        
        self.mapControl?.add(displayRule)
    }
}
