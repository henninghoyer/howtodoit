//
//  Task.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 12/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var taskBelongsToJob: Job

}
