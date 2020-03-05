//
//  DemosViewController.swift
//  Demos
//
//  Created by Daniel Nielsen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit

class DemoSelectorViewController: UITableViewController {

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(memoryLabel)
        memoryLabel.accessibilityIdentifier = "MemoryFootprint"
        memoryLabel.font = UIFont.boldSystemFont(ofSize: 10)
        memoryLabel.translatesAutoresizingMaskIntoConstraints = false
        memoryLabel.centerXAnchor.constraint(equalTo: window!.centerXAnchor).isActive = true
        if #available(iOS 11.0, *) {
            memoryLabel.topAnchor.constraint(equalTo: window!.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            memoryLabel.topAnchor.constraint(equalTo: window!.topAnchor, constant: 22).isActive = true
        }
        reportMemoryUsage()
    }
    
    @objc func reportMemoryUsage() -> Void {
        memoryLabel.text = Memory.formattedMemoryFootprint()
        self.perform(#selector(reportMemoryUsage), with: nil, afterDelay: 1)
    }
    
    let memoryLabel = UILabel()
    
    let demoControllerClasses:[UIViewController.Type] = [ ShowLocationController.self,
                                                          LocationDetailsController.self,
                                                          ShowMultipleLocationsController.self,
                                                          ShowRouteController.self,
                                                          AdvancedDirectionsController.self,
                                                          ShowVenueController.self,
                                                          ShowBuildingController.self,
                                                          ShowFloorController.self,
                                                          ChangeDisplaySettingController.self,
                                                          MapStyleController.self,
                                                          CustomFloorSelectorController.self,
                                                          ShowMyLocationController.self,
                                                          MultipleDatasetsController.self,
                                                          SearchMapController.self,
                                                          OfflineController.self,
                                                          LocationSourcesController.self,
                                                          ClusteringController.self,
                                                          CustomInfoWindowController.self,
                                                          AppUserRolesController.self
                                                        ]
    
    // MARK: Tableview delegate and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoControllerClasses.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell") {

            cell.textLabel?.text = displayNameFor( controllerClassName: String(describing: demoControllerClasses[indexPath.row]) )
            cell.accessibilityIdentifier = cell.textLabel?.text
            
            return cell
        }
        return UITableViewCell.init()
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
        
        return spaceSeparatedClassName.replacingOccurrences(of: "Controller", with: "Demo").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
