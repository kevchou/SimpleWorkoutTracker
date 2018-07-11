//
//  SelectWorkoutTableViewController.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-04.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit
import CoreData

class SelectWorkoutTableViewController: UITableViewController {
    
    var routines: [Routine]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: Navigation
extension SelectWorkoutTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // What happens after user selects a workout
        guard let destinationNavigationController = segue.destination as? UINavigationController,
            let dvc = destinationNavigationController.topViewController as? WorkoutSessionTableViewController,
            let index = tableView.indexPathForSelectedRow?.row
            else { return }
        
        // Get routine that was selected
        let routine = routines[index]
        
        // Core data stuff
        let managedContext = CoreDataHelper.shared.managedObjectContext()
        let workoutEntity = NSEntityDescription.entity(forEntityName: "Workout", in: managedContext)!
        let exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercise", in: managedContext)!
        
        // Create a new workout object
        let workout = NSManagedObject(entity: workoutEntity, insertInto: managedContext) as! Workout
        workout.name = routine.name
        workout.date = Date() // Today's day
        
        // add workouts
        if let exercises = routine.exercises {
            
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
        
        // Prepare WorkoutSessionVC
        dvc.workout = workout
        dvc.sourceVC = "SelectWorkout"
    }
    
}



// MARK: Data Source
extension SelectWorkoutTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWorkoutCellIdentifier", for: indexPath)
        
        // Configure cell
        let routine = routines[indexPath.row]
        
        cell.textLabel?.text = routine.name
        
        // detail text will list all exercises
        var exercises = [String]()
        for exercise in routine.exercises! {
            let e = exercise as String
            exercises.append(e)
        }
        cell.detailTextLabel?.text = exercises.joined(separator: ", ")

        return cell
    }
    
}
