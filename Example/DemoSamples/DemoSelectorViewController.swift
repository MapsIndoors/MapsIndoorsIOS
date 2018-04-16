//
//  DemosViewController.swift
//  Demos
//
//  Created by Daniel Nielsen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit

class DemoSelectorViewController: UITableViewController {

    let demoControllerClasses:[UIViewController.Type] = [ ShowLocationController.self,
                                                          LocationDetailsController.self,
                                                          ShowMultipleLocationsController.self,
                                                          ShowRouteController.self,
                                                          ShowVenueController.self,
                                                          ShowBuildingController.self,
                                                          ShowFloorController.self,
                                                          ChangeDisplaySettingController.self,
                                                          CustomFloorSelectorController.self,
                                                          ShowMyLocationController.self,
                                                          MultipleDatasetsController.self,
                                                          SearchMapController.self
                                                        ]
    
    // MARK: Tableview delegate and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoControllerClasses.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        cell.textLabel?.text = displayNameFor( controllerClassName: String(describing: demoControllerClasses[indexPath.row]) )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = demoControllerClasses[indexPath.row].init()
        navigationController?.pushViewController(vc, animated: true)
    }
}


private extension DemoSelectorViewController {

    func displayNameFor(controllerClassName : String ) -> String {
        
        // Camel case to space separated string:
        var spaceSeparatedClassName: String = ""
        
        let upperCase = CharacterSet.uppercaseLetters
        for scalar in controllerClassName.unicodeScalars {
            if upperCase.contains(scalar) {
                spaceSeparatedClassName.append(" ")
            }
            let character = Character(scalar)
            spaceSeparatedClassName.append(character)
        }
        
        return spaceSeparatedClassName.replacingOccurrences(of: "Controller", with: "Demo")
    }
}
