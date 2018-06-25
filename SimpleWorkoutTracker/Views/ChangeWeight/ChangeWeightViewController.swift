//
//  ChangeWeightViewController.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-11.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

class ChangeWeightViewController: UIViewController {

    var name: String!
    var weight: Double!
    
    var previousWorkouts: [Exercise] = []
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightStepper: UIStepper!
    @IBOutlet weak var previousWeightsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get previous workout stats
        previousWorkouts = Array(CoreDataHelper.shared.getPastExercisesFor(exerciseName: name).dropFirst())
        print(previousWorkouts)
        weightStepper.value = weight
        updateUI()
        
        previousWeightsTableView.dataSource = self
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        weight = weightStepper.value
        updateUI()
    }
    
    func updateUI() {
        weightLabel.text = "\(weight!) lb"
    }

}

// MARK:  TableView Data Source
extension ChangeWeightViewController: UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousWorkouts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousWorkoutHeaderCell", for: indexPath)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousWorkoutCell", for: indexPath) as! PreviousWorkoutTableViewCell
            
            let previousWorkout = previousWorkouts[indexPath.row - 1]
            
            cell.dateLabel.text = previousWorkout.workout?.date?.longString
            cell.weightLabel.text = previousWorkout.weight.clean + " lb"
            cell.setsLabel.text = "\(previousWorkout.sets)"
            cell.repsLabel.text = "\(previousWorkout.reps)"
            
            return cell
        }
    }
}



