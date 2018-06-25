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
    
    var routines: [Routine] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //CoreDataHelper.shared.loadSampleData()
        routines = CoreDataHelper.shared.getRoutines()
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
        
        // Prepare WorkoutSessionVC
        dvc.navigationItem.title = routine.name
        dvc.routineExercises = routine.exercises
    }
    
    @IBAction func unwindToSelectWorkout(segue: UIStoryboardSegue) {
        if segue.identifier == "finishWorkoutSegue" {
            
        }
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
