//
//  WorkoutHistoryTableViewController.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-28.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

class WorkoutHistoryTableViewController: UITableViewController {

    var workouts: [Workout]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }



    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHistoryCell", for: indexPath)

        // Configure the cell...
        let workout = workouts[indexPath.row]
        
        cell.textLabel?.text = workout.name
        cell.detailTextLabel?.text = workout.date?.longString

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let workout = workouts.remove(at: indexPath.row)
            
            CoreDataHelper.shared.managedObjectContext().delete(workout)
            do {
                try CoreDataHelper.shared.managedObjectContext().save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // What happens after user selects a workout
        guard let destinationNavigationController = segue.destination as? UINavigationController,
            let dvc = destinationNavigationController.topViewController as? WorkoutSessionTableViewController,
            let index = tableView.indexPathForSelectedRow?.row
            else { return }
        
        // Get routine that was selected
        let workout = workouts[index]
        
        // Prepare WorkoutSessionVC
        dvc.workout = workout
        dvc.sourceVC = "WorkoutHistory"

    }
    

}
