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
    
    var workout: Workout!
    var routineExercises: [String]? // Passed from SelectWorkoutVC. So we know what routine the user picked
    
    var currentWeightEditIndex: Int = 0 // Used for updating weight for each exercise
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core data stuff
        let managedContext = CoreDataHelper.shared.managedObjectContext()
        let workoutEntity = NSEntityDescription.entity(forEntityName: "Workout", in: managedContext)!
        let exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercise", in: managedContext)!
        
        // Create a new workout object
        workout = NSManagedObject(entity: workoutEntity, insertInto: managedContext) as! Workout
        
        // set to today's date
        workout.date = Date()
        

        // add workouts
        if let exercises = routineExercises {
            
            for exercise in exercises {

                let newExercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
                
                if let mostRecentExercise = CoreDataHelper.shared.getMostRecentExerciseFor(exerciseName: exercise) {
                    
                    // Get weight/sets/reps from most recent, if exists
                    newExercise.name = exercise
                    newExercise.sets = mostRecentExercise.sets
                    newExercise.reps = mostRecentExercise.reps
                    newExercise.weight = mostRecentExercise.weight
                    
                } else {
                    
                    // Else set default weight/sets/reps
                    newExercise.name = exercise
                    newExercise.sets = 5
                    newExercise.reps = 5
                    newExercise.weight = 45.0
                    
                }
                workout.addToExercises(newExercise)
            }
        }
    }
    
    
    @IBAction func finishButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            CoreDataHelper.shared.appDelegate().saveContext()
        }
    }
    
    
}


// MARK: Navigation

// what to do when the weight button in each cell is tapped. Segue to change weight.
extension WorkoutSessionTableViewController: WorkoutSessionProtocol {
    
    func segueToChangeWeightView(sender: UITableViewCell) {
        performSegue(withIdentifier: "ChangeWeightSegue", sender: sender)
    }
    
    func saveSetsAndReps(sender: UITableViewCell) {
        let indexPath = tableView.indexPath(for: sender)!
        let exercise = workout.exercises![indexPath.row - 2] as! Exercise
        print(exercise)
        
        let workoutCell = sender as! WorkoutExerciseTableViewCell
        
        if let setsText = workoutCell.setsTextField.text {
            exercise.sets = Int16(setsText)!
        }
        
        if let repsText = workoutCell.repsTextField.text {
            exercise.reps = Int16(repsText)!
        }
        
    }
}

extension WorkoutSessionTableViewController: WeightAndDateCellProtocol {
    
    func saveDate(sender: UITableViewCell) {
        let weightAndDateCell = sender as! WeightAndDateTableViewCell
        workout.date = weightAndDateCell.datePicker.date
    }
}




extension WorkoutSessionTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // segue to changeweightVC
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


