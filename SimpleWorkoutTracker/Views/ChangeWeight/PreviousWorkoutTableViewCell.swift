//
//  PreviousWorkoutTableViewCell.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-11.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

class PreviousWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
