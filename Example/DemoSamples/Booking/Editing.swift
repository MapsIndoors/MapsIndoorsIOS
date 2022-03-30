//
//  Editing.swift
//  Demos
//
//  Created by Daniel Nielsen on 21/09/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

import Foundation
import UIKit


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
        textField.placeholder = title
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
