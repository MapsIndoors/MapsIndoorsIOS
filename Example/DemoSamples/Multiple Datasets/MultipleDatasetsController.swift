//
//  DemosViewController.swift
//  Demos
//
//  Created by Daniel Nielsen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class MultipleDatasetsController: UITableViewController {
    
    let demoAPIKeys:[String] = [AppDelegate.mApiKey, "dbed3f9543b04b4e89ab1d01"]
    let demoVenueKeys:[String] = ["Stigsborgvej", "Aalborg City"]
    let demoSearchKeys:[String] = ["Toilet", "Seminar"]
    let demoPositions:[CLLocationCoordinate2D] = [
        CLLocationCoordinate2DMake(57.057964, 9.9504112),
        CLLocationCoordinate2DMake(57.0479435, 9.9308167)
    ]
    
    //This cleanup is only needed in this demo
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            MapsIndoors.provideAPIKey(AppDelegate.mApiKey, googleAPIKey: AppDelegate.gApiKey)
        }
    }
    
    // MARK: Tableview delegate and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoAPIKeys.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        cell.textLabel?.text = demoVenueKeys[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let apiKey = demoAPIKeys[indexPath.row]
        let venueKey = demoVenueKeys[indexPath.row]
        let searchKey = demoSearchKeys[indexPath.row]
        let position = demoPositions[indexPath.row]
        let vc = DatasetViewController.init(apiKey, venueKey, searchKey, position)
        navigationController?.pushViewController(vc, animated: true)
    }
}
