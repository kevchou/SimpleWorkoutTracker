//
//  WorkoutSessionTableViewController.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-09.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit
import CoreData

class WorkoutSessionTableViewController: UITableViewController {
    
    var bodyweight: BodyWeight?
    var workout: Workout!
    var sourceVC: String!
    
    var currentWeightEditIndex: Int = 0 // Used for updating weight for each exercise
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = workout.name
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            
            if self.sourceVC == "SelectWorkout" {
                CoreDataHelper.shared.managedObjectContext().delete(self.workout)
            } else if self.sourceVC == "WorkoutHistory" {
                CoreDataHelper.shared.managedObjectContext().rollback()
            }
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            
            // Save bodyweight and date
            let weightCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! WeightAndDateTableViewCell
            
            self.workout.date = weightCell.datePicker.date
            if let bodyweight = Double(weightCell.weightTextField.text!) {
                self.saveBodyWeight(bodyweight)
            }
            
            // save exercises
            for (i, exercise) in self.workout.exercises!.enumerated() {
                
                if let exercise = exercise as? Exercise {
                    
                    let exerciseCell = self.tableView.cellForRow(at: IndexPath(row: 2+i, section:0)) as! WorkoutExerciseTableViewCell
                    
                    exercise.weight = Double(exerciseCell.weightButton.titleLabel!.text!)!
                    exercise.sets = Int16(exerciseCell.setsTextField.text!)!
                    exercise.reps = Int16(exerciseCell.repsTextField.text!)!
                }
            }
            
            CoreDataHelper.shared.appDelegate().saveContext()
        }
    }
    
    func saveBodyWeight(_ bodyweight: Double) {
        let managedContext = CoreDataHelper.shared.managedObjectContext()
        let bodyweightEntity = NSEntityDescription.entity(forEntityName: "BodyWeight",
                                                          in: managedContext)!
        let bw = NSManagedObject(entity: bodyweightEntity,
                                 insertInto: managedContext) as! BodyWeight
        bw.bodyweight = bodyweight
        bw.date = self.workout.date
    }
    
}




// MARK:- Protocols

// MARK: Workout Exercise TableViewCell
// what to do when the weight button in each cell is tapped. Segue to change weight.
extension WorkoutSessionTableViewController: WorkoutExerciseTableViewCellDelegate {
    
    func segueToChangeWeightView(sender: UITableViewCell) {
        performSegue(withIdentifier: "ChangeWeightSegue", sender: sender)
    }
    
}

// MARK:- Navigation
extension WorkoutSessionTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*** segue to changeweightVC ***/
        guard
            let dvc = segue.destination as? ChangeWeightViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            else { return }
        
        // Save index selected for saving later
        currentWeightEditIndex = indexPath.row - 2
        
        // Get exercise of cell selected and prepare changeweightVC variables
        let exercise = workout.exercises![currentWeightEditIndex] as! Exercise
        dvc.name = exercise.name
        dvc.weight = exercise.weight
        
    }
    
    @IBAction func unwindToWorkoutSession(segue: UIStoryboardSegue) {
        
        if segue.identifier == "SaveWeightSegue" {
            
            // Change current weight to newly inputted value
            let svc = segue.source as! ChangeWeightViewController
            (workout.exercises![currentWeightEditIndex] as! Exercise).weight = svc.weight
            tableView.reloadData()
        }
        
    }
}


// MARK: DataSource

extension WorkoutSessionTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + workout.exercises!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.row) {
        case 0:
            // Weight and Date cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeightAndDateCellIdentifier", for: indexPath) as! WeightAndDateTableViewCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            cell.weightTextField.text = ""
            cell.datePicker.date = workout.date!
            cell.dateTextField.text = workout.date!.longString
            
            if self.sourceVC == "SelectWorkout" {
                cell.weightStackView.isHidden = false
            } else if self.sourceVC == "WorkoutHistory" {
                cell.weightStackView.isHidden = true
            }
            
            return cell
            
        case 1:
            // Header names
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHeadersCellIdentifier", for: indexPath)
            
            return cell
            
        default:
            // Exercise cells
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCellIdentifier", for: indexPath) as! WorkoutExerciseTableViewCell
            
            // -2 to account for first two cells
            let exercise = workout.exercises![indexPath.row - 2] as! Exercise

            cell.exerciseLabel.text = exercise.name
            cell.weightButton.setTitle(exercise.weight.clean, for: .normal)
            cell.setsTextField.text = "\(exercise.sets)"
            cell.repsTextField.text = "\(exercise.reps)"
            cell.delegate = self

            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        }
    }
}


