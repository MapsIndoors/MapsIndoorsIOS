//
//  BookableLocationsController.swift
//
//  Created by Daniel Nielsen on 25/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors
//

/***
 ---
 title: Performing Location Bookings in MapsIndoors
 ---
 
 In this tutorial we will create a Booking experience using the Booking Service in MapsIndoors. You will learn how to list bookable Locations, list Bookings for a Location and perform new Bookings using the Booking Service, `MPBookingService`.
 
 Please note that a MapsIndoors dataset can only have bookable resources if an integration with a booking provider exists. Current examples of booking providers are _Google Calendar_ and _Microsoft Office 365_. These providers and more can be added and integrated to your MapsIndoors project by request. It is a prerequisite for this tutorial that the API key used refers to a dataset containing bookable Locations.
 
 We will start by listing bookable Locations. Create a class `BookableLocationsController` inheriting from `UITableViewController`.
 ***/

class BookableLocationsController: UITableViewController {
    
    /***
    Create a private property that should hold our bookable Locations.
    ***/
    private var bookableLocations = [MPLocation]()
    
    private var locationsConfiguredForBooking = [MPLocation]()
    
    private let authHelper = SingleSignOnHelper.init()
    
    
    private let initialTenantId = "f46992fe-da99-4721-a5e9-005a67f08557"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapsIndoors.provideAPIKey("4808bca6db85450c819c020c", googleAPIKey: nil)
    }
    
    /***
    In your `viewDidAppear()` method,
     1. Initialise a `MPBookableQuery` object with a timespan for your potential Booking.
     1. Call `getLocationsConfiguredForBooking()` on the `MPBookingService` instance.
     1. Assign the returned locations to your `bookableLocations` property.
     ***/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Auth", style: .plain, target: self, action: #selector(openAuthConfig))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Login", style: .plain, target: self, action: #selector(openLogin))
        
        refresh()
        
    }
    
    func refresh() {
        let bookableQuery = MPBookableQuery.init()
        bookableQuery.startTime = Date.init()
        bookableQuery.endTime = bookableQuery.startTime.advanced(by: 60*60)

        weak var wself = self

        MPBookingService.sharedInstance().getLocationsConfiguredForBooking(query: bookableQuery) { locations, error in
            if let _locations = locations {
                wself?.locationsConfiguredForBooking = _locations
                wself?.tableView.reloadData()
            }
        }
        
        MPBookingService.sharedInstance().getBookableLocations(using: bookableQuery, completion: { locations, error in
            if let _locations = locations {
                wself?.bookableLocations = _locations
                wself?.tableView.reloadData()
            }
        })
    }
    
    @objc func openLogin() {
        
        authHelper.openLoginFlow(for: self) { [self] in
            if let token = authHelper.authState?.lastTokenResponse?.accessToken {
                MapsIndoors.accessToken = token
                MPBookingService.sharedInstance().authenticationConfig = MPBookingAuthConfig.init(accessToken: token)
                MPBookingService.sharedInstance().authenticationConfig?.tenantId = initialTenantId
                refresh()
            }
        }
        
    }
    
    @objc func openAuthConfig() {
        let accessToken = MPBookingService.sharedInstance().authenticationConfig?.accessToken
        let tenant = MPBookingService.sharedInstance().authenticationConfig?.tenantId ?? initialTenantId
        let tokenEditVC = FieldEditController.init()
        tokenEditVC.title = "Access Token"
        tokenEditVC.beginEdit(initialValue: accessToken) { [self] (value) in
            if value.count > 0 {
                MPBookingService.sharedInstance().authenticationConfig = MPBookingAuthConfig.init(accessToken: value)
                
                let tenantEditVC = FieldEditController.init()
                tenantEditVC.title = "Tenant ID"
                tenantEditVC.beginEdit(initialValue: tenant) { [self] (value) in
                    if value.count > 0 {
                        MPBookingService.sharedInstance().authenticationConfig?.tenantId = value
                    }
                    refresh()
                }
                present(tenantEditVC, animated: true, completion: nil)
                
            } else {
                MPBookingService.sharedInstance().authenticationConfig = nil
                refresh()
            }
        }
        present(tokenEditVC, animated: true, completion: nil)
    }
    
    /***
     In `numberOfSections(in tableView:)`, return 1 since we only need one section.
     ***/
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Available Locations"
        } else {
            return "All Locations"
        }
    }
    
    /***
     In `tableView(:numberOfRowsInSection section:)`, return the size of `bookableLocations`.
     ***/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return bookableLocations.count
        } else {
            return locationsConfiguredForBooking.count
        }
    }
    
    /***
     In `tableView(:cellForRowAt indexPath:)`, create a `UITableViewCell` with the current Locations name as the text for the label.
     ***/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init()
        
        var list = locationsConfiguredForBooking
        if indexPath.section == 0 {
            list = bookableLocations
        }
        
        let location = list[indexPath.row]
        cell.textLabel?.text = location.name

        return cell

    }
    
    /***
     In `tableView(:didSelectRowAt indexPath:)`, get the relevant `MPLocation` for the `indexPath`. Initialise a `BookingsController` which we will implement next. Assign the selected location to a `bookableLocation` property on `BookingsController` and push the controller to the navigation stack.
     ***/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let bookingsVC = BookingsController.init()
        
        var list = locationsConfiguredForBooking
        if indexPath.section == 0 {
            list = bookableLocations
        }
        
        let location = list[indexPath.row]
        bookingsVC.bookableLocation = location
    
        navigationController?.pushViewController(bookingsVC, animated: true)

    }
    //
}
