//
//  WorkoutExerciseTableViewCell.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-09.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

protocol WorkoutExerciseTableViewCellDelegate {
    func segueToChangeWeightView(sender: UITableViewCell)
}

class WorkoutExerciseTableViewCell: UITableViewCell {
    
    var delegate: WorkoutExerciseTableViewCellDelegate?
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
    // When Set or Rep textfield is tapped
    @IBAction func editingDidBegin(_ sender: UITextField) {
        
        // Add a toolbar with a Done button
        let toolbar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WorkoutExerciseTableViewCell.doneButtonTapped))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        
        sender.inputAccessoryView = toolbar
    }
    
    
    @objc func doneButtonTapped() {
        setsTextField.resignFirstResponder()
        repsTextField.resignFirstResponder()
    }
    
    @IBAction func weightButtonTapped(_ sender: UIButton) {
        delegate?.segueToChangeWeightView(sender: self)
    }
    
   
}
