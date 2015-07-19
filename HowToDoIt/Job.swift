//
//  Job.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 19/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import Foundation
import CoreData

@objc(Job)
class Job: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var jobHasTask: NSSet

}
