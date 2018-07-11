//
//  BodyWeightHistoryTableViewController.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-27.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

class BodyWeightHistoryTableViewController: UITableViewController {
    
    var bodyweights: [BodyWeight]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyweights = CoreDataHelper.shared.getPastBodyWeight()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bodyweights.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyWeightHistoryCell", for: indexPath)
        
        // Configure the cell...
        let bodyweight = bodyweights[indexPath.row]
        
        cell.textLabel?.text = bodyweight.date?.longString
        cell.detailTextLabel?.text = bodyweight.bodyweight.clean + " lb"
        
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
            
            let bodyweight = bodyweights.remove(at: indexPath.row)
    
            CoreDataHelper.shared.managedObjectContext().delete(bodyweight)
            do {
                try CoreDataHelper.shared.managedObjectContext().save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
