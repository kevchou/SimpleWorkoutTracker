//
//  WeightAndDateTableViewCell.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-09.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

protocol WeightAndDateCellProtocol {
    func saveDate(sender: UITableViewCell)
}

class WeightAndDateTableViewCell: UITableViewCell {
    
    var delegate: WeightAndDateCellProtocol?
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // update view
    }
    
    @IBAction func weightEditDidBegin(_ sender: UITextField) {
        // Add a toolbar with a Done button to the numberpad
        let toolbar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WeightAndDateTableViewCell.saveWeight))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        
        sender.inputAccessoryView = toolbar
    }
    
    @objc func saveWeight() {
        weightTextField.resignFirstResponder()
    }
    
    
    @IBAction func dateEditDidBegin(_ sender: UITextField) {
        
        // UIDatepicker as keyboard
        let datePickerView: UIDatePicker = self.datePicker
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(WeightAndDateTableViewCell.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        // add toolbar on top of DatePicker keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WeightAndDateTableViewCell.dismissPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WeightAndDateTableViewCell.todayDate))
        
        toolBar.setItems([todayButton, spaceButton, doneButton], animated: false)
        sender.inputAccessoryView = toolBar
    }
    
    
    @objc
    func datePickerValueChanged(sender: UIDatePicker) {
        updateDateField()
        delegate?.saveDate(sender: self)
    }
    
    @objc func dismissPicker() {
        dateTextField.endEditing(true)
    }
    
    func updateDateField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func todayDate() {
        datePicker.date = Date()
        updateDateField()
    }

}
