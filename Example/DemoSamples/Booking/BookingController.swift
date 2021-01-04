//
//  BookingController.swift
//
//  Created by Daniel Nielsen on 25/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors
//

/***
 We need a third controller to display, edit and perform an actual Booking.
 
 We will create an enum model to keep track on the different parts of the `MPBooking` model displayed through the view controller.
 ***/
enum BookingRow : Int {
    case title = 0
    case description = 1
    case start = 2
    case end = 3
    case id = 4
    case count = 5
}

/***
 Create `BookingsController` inheriting once again from `UITableViewController`.
 ***/
class BookingController: UITableViewController {
    
    /***
     Create a public property `booking` that will hold our Booking.
     ***/
    var booking = MPBooking.init()
    
    /***
     Create some private properties `bookBtn` and `cancelBtn` that is to be placed dynamically in the `navigationItem`.
     ***/
    private let bookBtn = UIBarButtonItem.init(title: "Create Booking", style: .plain, target: self, action: #selector(book))
    private let cancelBtn = UIBarButtonItem.init(title: "Cancel Booking", style: .plain, target: self, action: #selector(cancel))

    /***
     Create a method `updateButtons()` that will either place a `bookBtn` if there is no `bookingId` on the Booking, which means it was created locally, or place a `cancelBtn` if a `bookingId` exist for the Booking, which means it was selected from a list of Bookings fetched from the `MPBookingService`.
     ***/
    private func updateButtons() {
        if booking.bookingId != nil {
            self.navigationItem.rightBarButtonItem = cancelBtn
        } else {
            self.navigationItem.rightBarButtonItem = bookBtn
        }
    }
    
    /***
     In your `viewDidLoad()` method, just call the `updateButtons()` method.
     ***/
    override func viewDidLoad() {

        updateButtons()

    }
    
    /***
     Create an Objective-C exposed method `book()` which will be use by our `UIBarButtonItem` inserted in `viewDidLoad()`. In the `book()` mehod, call `perform(booking)` on the `MPBookingService` instance with our Booking object as input. If all goes well and we have a Booking returned in the block, we assign this new Booking to our `booking` propery and refresh our views. If not, we assume that we have an error, and show this in an alert controller.
     ***/
    @objc private func book() {
        weak var wself = self
        MPBookingService.sharedInstance().perform(booking) { (booking, error) in
            if let b = booking {
                wself?.booking = b
                wself?.updateButtons()
                wself?.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Ooops!", message: "\(error.debugDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    /***
     Create another Objective-C exposed method `cancel()` which will be use by our `UIBarButtonItem` inserted in `viewDidLoad()`. In the `cancel()` mehod, call `cancel(booking)` on the `MPBookingService` instance with our Booking object as input. If all goes well and we have a Booking returned in the block, we assign this new Booking to our `booking` propery and refresh our views. If not, we assume that we have an error, and show this in an alert controller.
     ***/
    @objc private func cancel() {
        weak var wself = self
        MPBookingService.sharedInstance().cancel(booking) { (booking, error) in
            if error == nil {
                let alert = UIAlertController(title: "Booking was cancelled!", message: "Booking was successfully cancelled!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                wself?.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Ooops!", message: "\(error.debugDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                wself?.present(alert, animated: true)
            }
        }
    }
    
    /***
     In `numberOfSections(in tableView:)`, return 1 since we only need one section.
     ***/
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /***
     In `tableView(:numberOfRowsInSection section:)`, return the value of `BookingRow.count.rawValue`.
     ***/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingRow.count.rawValue
    }

    /***
     In `tableView(:cellForRowAt indexPath:)`, create a `UITableViewCell` and create a switch control structure by initialising a `BookingRow` enum value from `indexPath.row`. Based on the cases, populate the `textLabel` with `title`, `bookingDescription`, `startTime`, `endTime` and `bookingId` from your `MPBooking` instance.
     ***/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)

        switch BookingRow.init(rawValue: indexPath.row)  {
        case .title:
            cell.textLabel?.text = booking.title ?? ""
            cell.detailTextLabel?.text = "Title"
        case .description:
            cell.textLabel?.text = booking.bookingDescription ?? ""
            cell.detailTextLabel?.text = "Description"
        case .start:
            cell.textLabel?.text = "\(booking.startTime ?? Date.init())"
            cell.detailTextLabel?.text = "Start time"
        case .end:
            cell.textLabel?.text = "\(booking.endTime ?? Date.init().addingTimeInterval(60*60))"
            cell.detailTextLabel?.text = "End time"
        case .id:
            cell.textLabel?.text = booking.bookingId ?? ""
            cell.detailTextLabel?.text = "Booking id"
        default : ()
        }

        return cell

    }
    
    /***
     In `tableView(:cellForRowAt indexPath:)`, create a switch control structure again by initialising a `BookingRow` enum value from `indexPath.row`. Based on the cases, either initialise and present `FieldEditController` or `DatePickerController` which we will implement next.
     ***/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        weak var wself = self

        switch BookingRow.init(rawValue: indexPath.row) {
        case .title:
            let fieldEditVC = FieldEditController.init()
            fieldEditVC.title = "Edit Title"
            fieldEditVC.beginEdit(initialValue: booking.title) { (value) in
                wself?.booking.title = value
                wself?.tableView.reloadData()
            }
            present(fieldEditVC, animated: true, completion: nil)
        case .description:
            let fieldEditVC = FieldEditController.init()
            fieldEditVC.title = "Edit Description"
            fieldEditVC.beginEdit(initialValue: booking.bookingDescription) { (value) in
                wself?.booking.bookingDescription = value
                wself?.tableView.reloadData()
            }
            present(fieldEditVC, animated: true, completion: nil)
        case .start:
            let dateEditVC = DatePickerController.init()
            dateEditVC.title = "Edit Start Date"
            dateEditVC.beginEdit(initialValue: booking.startTime) { (value) in
                wself?.booking.startTime = value
                wself?.tableView.reloadData()
            }
            present(dateEditVC, animated: true, completion: nil)
        case .end:
            let dateEditVC = DatePickerController.init()
            dateEditVC.title = "Edit End Date"
            dateEditVC.beginEdit(initialValue: booking.endTime) { (value) in
                wself?.booking.endTime = value
                wself?.tableView.reloadData()
            }
            present(dateEditVC, animated: true, completion: nil)
        default : ()
        }
    }
    //
}

/***
 Creating UI for editing text and dates is outside the scope of this tutorial. But since we need it for creating the actual Booking, you are advised to just insert the following 3 controllers into your code.
 
 1. A controller `EditController` for arranging the presented editing view skeleton.
 ***/
class EditController: UIViewController {
    let doneButton = UIButton.init()
    let titleLabel = UILabel.init()
    override var title: String? { didSet { titleLabel.text = title } }
    let sw = UIStackView.init()
    func spacer() -> UIView {
        return UIView.init()
    }
    override func viewDidLoad() {
        sw.addArrangedSubview(doneButton)
        sw.addArrangedSubview(titleLabel)
        sw.spacing = 40
        sw.alignment = .center
        sw.axis = .vertical
        let backgroundView = UIView.init(frame: CGRect(x: 0,y: 0,width: 3000,height: 3000))
        backgroundView.backgroundColor = UIColor.systemBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        sw.insertSubview(backgroundView, at: 0)
        view = sw

        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.link, for: .normal)
        doneButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

/***
 2. A controller `DatePickerController` inheriting `EditController` presenting and managing the date picker.
 ***/
class DatePickerController: EditController {
    
    private let datePicker = UIDatePicker.init()
    var didEdit : ((_ value:Date) -> Void)?
    func beginEdit(initialValue:Date?, didEdit: @escaping ((Date) -> Void)) {
        datePicker.date = initialValue ?? Date.init()
        self.didEdit = didEdit
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        datePicker.addTarget(self, action: #selector(didEditDate), for: .allEvents)

        sw.addArrangedSubview(datePicker)
        sw.addArrangedSubview(spacer())

    }

    @objc func didEditDate() {
        didEdit?(datePicker.date)
    }
}

/***
 3. A controller `FieldEditController` inheriting `EditController` presenting and managing the text field.
 ***/
class FieldEditController: EditController, UITextFieldDelegate {

    private let textField = UITextField.init()
    private var didEdit: ((_ value:String) -> Void)?
    func beginEdit(initialValue:String?, didEdit: @escaping ((String) -> Void)) {
        textField.text = initialValue ?? ""
        self.didEdit = didEdit
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        sw.addArrangedSubview(textField)
        sw.addArrangedSubview(spacer())

        textField.becomeFirstResponder()
        textField.delegate = self

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        didEdit?(textField.text ?? "")
    }
}

/***
 This concludes the tutorial about Booking in the MapsIndoors  iOS SDK. Depending on your dataset you should not be far from a working Booking experience where you can list Bookable Locations, list Bookings and create new Bookings.
 ***/

///
