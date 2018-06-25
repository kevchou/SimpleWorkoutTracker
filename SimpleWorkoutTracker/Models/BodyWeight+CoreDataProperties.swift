//
//  BodyWeight+CoreDataProperties.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-24.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//
//

import Foundation
import CoreData


extension BodyWeight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BodyWeight> {
        return NSFetchRequest<BodyWeight>(entityName: "BodyWeight")
    }

    @NSManaged public var date: Date?
    @NSManaged public var bodyweight: Double

}
