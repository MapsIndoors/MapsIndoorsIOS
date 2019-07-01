//
//  MapStyleController.swift
//  Demos
//
//  Created by Daniel Nielsen on 12/03/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class MapStyleController: UIViewController {

    /***
     Add a `GMSMapView` and a `MPMapControl` to the class
     ***/
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    var venue:MPVenue? = nil
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /***
         Setup map so that it shows the demo venue and initialise mapControl
         ***/
        self.map = GMSMapView.init(frame: CGRect.zero)
        self.mapControl = MPMapControl.init(map: self.map!)
        
        self.view = self.map
        
        MPVenueProvider().getVenuesWithCompletion { (coll, err) in
            let venues:[MPVenue] = coll!.venues as! [MPVenue]
            self.venue = venues.first!
            let bounds = self.venue!.getBoundingBox()
            self.map?.animate(with: GMSCameraUpdate.fit(bounds!))

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Style", style: .plain, target: self, action: #selector(self.activateMapStyleSelector(sender:)))
        }
        
    }

    @objc
    func activateMapStyleSelector(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Map Style", message: "Please Select Map Style", preferredStyle: .alert)
        
        for style in venue!.styles! {
            let action = UIAlertAction(title: style.folder, style: .default) { (action) in
                self.mapControl?.mapStyle = style
            }
            alertController.addAction( action )
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction( cancel )
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
}
