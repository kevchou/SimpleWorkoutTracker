//
//  Exercise+CoreDataProperties.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-21.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var weight: Double
    @NSManaged public var sets: Int16
    @NSManaged public var reps: Int16
    @NSManaged public var workout: Workout?

}
