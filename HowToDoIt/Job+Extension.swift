//
//  Job+Extension.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 12/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import Foundation
import CoreData

extension Job {
    
    static func createJobWithName(name: String) -> Job {
        let job = NSEntityDescription.insertNewObjectForEntityForName(kJobEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Job
        
        job.name = name
        
        CoreData.sharedInstance.saveContext()
        
        return job
    }
    
}