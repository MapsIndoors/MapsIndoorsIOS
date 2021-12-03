//
//  SingleSignOnController.swift
//  Demos
//
//  Created by Daniel Nielsen on 13/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

import UIKit
import AppAuth
import MapsIndoors

class SingleSignOnController: UIViewController {
    
    private var map: GMSMapView? = nil
    private var mapControl: MPMapControl? = nil
    private let authHelper = SingleSignOnHelper.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapsIndoors.delegate = self
        
        MapsIndoors.provideAPIKey("rtxauth", googleAPIKey: nil)
        
        showMap()
        
        authHelper.openLoginFlow(for: self) { [self] in
            MapsIndoors.accessToken = authHelper.authState?.lastTokenResponse?.accessToken
            showLocation()
        }
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func showLocation() {
        let query = MPQuery.init()
        let filter = MPFilter.init()
        
        query.query = "Paris"
        filter.take = 1
        
        MPLocationService.sharedInstance().getLocationsUsing(query, filter: filter) { [weak self] (locations, error) in
            if let firstLocation = locations?.first {
                self?.mapControl?.go(to: firstLocation)
                self?.mapControl?.selectedLocation = firstLocation
            }
        }
    }
    
    private func showMap() {
        
        self.map = GMSMapView.init(frame: CGRect.zero)
        
        self.view = self.map
        
        self.mapControl = MPMapControl.init(map: self.map!)
        
        showLocation()
        
    }
    
}

extension SingleSignOnController : MPMapsIndoorsDelegate {
    func onError(_ error: Error) {
        print("Got error \(error.localizedDescription)")
    }
}
