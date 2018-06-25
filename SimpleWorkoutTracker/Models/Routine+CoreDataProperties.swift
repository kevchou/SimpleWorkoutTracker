//
//  Routine+CoreDataProperties.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-21.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var name: String?
    @NSManaged public var exercises: [String]?

}
