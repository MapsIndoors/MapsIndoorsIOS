//
//  BookingsController.swift
//
//  Created by Daniel Nielsen on 25/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors
//

/***
 Create a new controller, `BookingsController` inheriting again from `UITableViewController`. This controller will list the Bookings for a locations within a timespan, as well as give access to creating new and editing bookings.
 ***/
class BookingsController: UITableViewController {

    /***
     Create a public property `bookableLocation` that will hold the Location we want to book.
     ***/
    var bookableLocation : MPLocation?
    /***
     Create a private property `bookings` that can hold the Location's bookings.
     ***/
    private var bookings = [MPBooking]()
    //

    override func viewDidLoad() {

        /***
         In your `viewDidLoad()` method, initialise a `UIBarButtonItem` with the title `Book`targeting `newBooking` which we will create later. Add the button to the `navigationItem`.
         ***/
        let button = UIBarButtonItem.init(title: "Book", style: .plain, target: self, action: #selector(newBooking))
        self.navigationItem.rightBarButtonItem = button

        /***
         Also in your `viewDidLoad()` method, initialise a `MPBookingsQuery`with the `MPLocation` stored in `bookableLocation` and a timespan, in this example 24 hours starting one hour ago.
         ***/
        let bookingsQuery = MPBookingsQuery.init()
        bookingsQuery.location = bookableLocation
        bookingsQuery.startTime = Date.init().advanced(by: -60*60)
        bookingsQuery.endTime = bookingsQuery.startTime?.advanced(by: 24*60*60)
        
        /***
         Lastly in your `viewDidLoad()` method, call `getBookingsUsing(bookingsQuery)`with the `MPBookingsQuery` we just created. Store the returned Bookings in our `bookings` property.
         ***/
        weak var wself = self
        MPBookingService.sharedInstance().getBookingsUsing(bookingsQuery) { (bookings, error) in
            if let _bookings = bookings {
                wself?.bookings = _bookings
                wself?.tableView.reloadData()
            }
        }
        //
        
    }
    
    /***
     In `numberOfSections(in tableView:)`, return 1 since we only need one section.
     ***/
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /***
     In `tableView(:numberOfRowsInSection section:)`, return the size of `bookings`.
     ***/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    /***
     In `tableView(:cellForRowAt indexPath:)`, create a `UITableViewCell` with the current Booking title as the text for the label.
     ***/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init()

        let booking = bookings[indexPath.row]

        cell.textLabel?.text = booking.title

        return cell

    }
    
    /***
     In `tableView(:didSelectRowAt indexPath:)`, get the relevant `MPBooking` for the `indexPath` and call `editBooking()` with that Booking.
     ***/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let booking = bookings[indexPath.row]

        editBooking(booking: booking)

    }
    
    /***
     Create a method `editBooking(booking:)`. In this mehod, initialise a `BookingController` which we will implement next. Assign the selected booking to the `BookingController` and push the controller to the navigation stack.
     ***/
    func editBooking(booking:MPBooking) {

        let bookingVC = BookingController.init()
        bookingVC.booking = booking

        navigationController?.pushViewController(bookingVC, animated: true)

    }
    
    /***
     Create an Objective-C exposed method `newBooking()` which will be use by our `UIBarButtonItem` created in `viewDidLoad()`. In the `newBooking()` mehod, initialise a new `MPBooking` instance and provide some default values for the Booking. Call the newly created `editBooking(booking:)` with the Booking instance.
     ***/
    @objc func newBooking() {

        let booking = MPBooking.init()
        booking.location = bookableLocation
        booking.title = "Meeting"
        booking.startTime = Date.init()
        booking.participantIds = ["myemail@email.com"]
        booking.endTime = booking.startTime!.addingTimeInterval(60*60)
        editBooking(booking: booking)
    }
    //
}
