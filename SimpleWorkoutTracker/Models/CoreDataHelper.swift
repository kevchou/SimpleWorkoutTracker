//
//  CoreDataHelper.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-23.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    static let shared = CoreDataHelper()
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func managedObjectContext() -> NSManagedObjectContext {
        return self.appDelegate().persistentContainer.viewContext
    }
    
    func getRoutines() -> [Routine] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        
        let result: [Routine]
        
        do {
            result = try CoreDataHelper.shared.managedObjectContext().fetch(request) as! [Routine]
        } catch {
            print("Getting Routines failed")
            result = []
        }
        
        return result
    }
    
    func getPastBodyWeight() -> [BodyWeight] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BodyWeight")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        let result: [BodyWeight]
        do {
            result = try CoreDataHelper.shared.managedObjectContext().fetch(request) as! [BodyWeight]
        } catch let error {
            print(error.localizedDescription)
            result = []
        }
        return result
    }
    
    func getPastWorkouts() -> [Workout] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        let result: [Workout]
        
        do {
            result = try CoreDataHelper.shared.managedObjectContext().fetch(request) as! [Workout]
        } catch let error {
            print(error.localizedDescription)
            result = []
        }
        return result
    }
    
    func getPastExercisesFor(exerciseName: String) -> [Exercise] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        
        let predicate = NSPredicate(format: "name = %@", exerciseName)
        request.predicate = predicate
        
        let sort = NSSortDescriptor(key: "workout.date", ascending: false)
        request.sortDescriptors = [sort]
        
        let result: [Exercise]
        
        do {
            result = try CoreDataHelper.shared.managedObjectContext().fetch(request) as! [Exercise]
        } catch let error {
            print(error.localizedDescription)
            result = []
        }
        return result
    }
    
    func getMostRecentExerciseFor(exerciseName: String) -> Exercise? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        
        let predicate = NSPredicate(format: "name = %@", exerciseName)
        request.predicate = predicate
        
        let sort = NSSortDescriptor(key: "workout.date", ascending: false)
        request.sortDescriptors = [sort]
        
        let result: [Exercise]
        
        do {
            result = try CoreDataHelper.shared.managedObjectContext().fetch(request) as! [Exercise]
        } catch let error {
            print(error.localizedDescription)
            result = []
        }
        return result.first
    }
    
    
    func loadSampleData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        let managedContext = self.managedObjectContext()
        
        // Load body weight
        let bodyweightEntity = NSEntityDescription.entity(forEntityName: "BodyWeight", in: managedContext)!
        
        let bw1 = NSManagedObject(entity: bodyweightEntity, insertInto: managedContext) as! BodyWeight
        bw1.date = dateFormatter.date(from: "2017-12-31")
        bw1.bodyweight = 185
        
        let bw2 = NSManagedObject(entity: bodyweightEntity, insertInto: managedContext) as! BodyWeight
        bw2.date = dateFormatter.date(from: "2017-06-01")
        bw2.bodyweight = 175

        // Load Routines
        let routineEntity = NSEntityDescription.entity(forEntityName: "Routine", in: managedContext)!
        
        let routine1 = NSManagedObject(entity: routineEntity, insertInto: managedContext) as! Routine
        routine1.name = "Power Upper"
        routine1.exercises = ["Bench Press", "Incline Dumbbell Press", "Bentover Row", "Lat Pull Down", "Barbell Curl", "Skullcrushers", "Overhead Press"]
        
        let routine2 = NSManagedObject(entity: routineEntity, insertInto: managedContext) as! Routine
        routine2.name = "Power Lower"
        routine2.exercises = ["Squats","Deadlifts","Leg Press","Hamstring Curl","Standing Calf Press"]
        
        let routine3 = NSManagedObject(entity: routineEntity, insertInto: managedContext) as! Routine
        routine3.name = "Hypertrophy Upper"
        routine3.exercises = ["Incline Barbell Press", "Flat Bench Fly", "One Arm Dumbbell Row","Incline Dumbbell Curl", "Dumbell Lateral Raises", "Cable Tricep Extensions", "Seated Cable Row", "Dips"]
        
        let routine4 = NSManagedObject(entity: routineEntity, insertInto: managedContext) as! Routine
        routine4.name = "Hypertrophy Lower"
        routine4.exercises = ["Front Squat",  "Barbell Lunge", "Leg Extension", "Leg Curl", "Calf Raises", "Calf Press"]
        
        
        // Load sample workouts
        let workoutEntity = NSEntityDescription.entity(forEntityName: "Workout", in: managedContext)!
        let exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercise", in: managedContext)!
        
        let workout1 = NSManagedObject(entity: workoutEntity, insertInto: managedContext) as! Workout
        workout1.date = dateFormatter.date(from: "2018-01-01")
        let e1 = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
        e1.name = "Front Squat"
        e1.sets = 4
        e1.reps = 12
        e1.weight = 125
        
        let e2 = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
        e2.name = "Barbell Lunge"
        e2.sets = 4
        e2.reps = 8
        e2.weight = 85
        
        let e3 = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
        e3.name = "Leg Extension"
        e3.sets = 4
        e3.reps = 12
        e3.weight = 150
        
        workout1.addToExercises(e1)
        workout1.addToExercises(e2)
        workout1.addToExercises(e3)

        let workout2 = NSManagedObject(entity: workoutEntity, insertInto: managedContext) as! Workout
        workout2.date = dateFormatter.date(from: "2018-01-03")
        
        let e11 = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
        e11.name = "Front Squat"
        e11.sets = 4
        e11.reps = 12
        e11.weight = 135
        
        let e12 = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
        e12.name = "Barbell Lunge"
        e12.sets = 4
        e12.reps = 8
        e12.weight = 85
        
        let e13 = NSManagedObject(entity: exerciseEntity, insertInto: managedContext) as! Exercise
        e13.name = "Leg Extension"
        e13.sets = 4
        e13.reps = 12
        e13.weight = 150
        
        workout2.addToExercises(e11)
        workout2.addToExercises(e12)
        workout2.addToExercises(e13)
        
        self.appDelegate().saveContext()
    }
}
