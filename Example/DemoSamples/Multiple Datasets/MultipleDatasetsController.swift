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

class MultipleDatasetsController: UIViewController, MPMapControlDelegate {
    
    let demoAPIKeys:[String] = [AppDelegate.mApiKey, "173386a6ff5e43cead3e396b"]
    let demoVenueKeys:[String] = ["Stigsborgvej", "Aalborg City"]
    
    var map: GMSMapView? = nil
    var mapControl: MPMapControl? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Datasets", style: .plain, target: self, action: #selector(self.activateDatasetSelector(sender:)))
        
        map = GMSMapView.init(frame: CGRect.zero)
        
        map?.accessibilityElementsHidden = false
        
        view = self.map
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc
    func activateDatasetSelector(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Select Dataset", message: nil, preferredStyle: .alert)

        weak var _self = self
        
        for i in 0..<demoAPIKeys.count {
            let apiKey = demoAPIKeys[i]
            let venueName = demoVenueKeys[i]
            let action = UIAlertAction(title: "\(venueName)", style: .default) { (action) in
                
                MapsIndoors.provideAPIKey(apiKey, googleAPIKey: AppDelegate.gApiKey)
                
                if _self?.mapControl == nil {

                    _self?.mapControl = MPMapControl.init(map: self.map!)
                    _self?.mapControl?.delegate = self
                    
                }
                
                let q = MPQuery.init()
                q.query = venueName
                let f = MPFilter.init()
                
                MPLocationService.sharedInstance().getLocationsUsing(q, filter: f) { (locations, err) in
                    if let location = locations?.first {
                        _self?.mapControl?.selectedLocation = location
                        _self?.mapControl?.go(to: location)
                    }
                }
                
            }
            alertController.addAction( action )
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction( cancel )
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
