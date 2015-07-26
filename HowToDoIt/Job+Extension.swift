//
//  Job+Extension.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 12/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import Foundation
import CoreData

//for Option 2
private var jobDidSaveArray = [Job]()

extension Job {
    
    static func createJobWithName(name: String) -> Job {
        let job = NSEntityDescription.insertNewObjectForEntityForName(kJobEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Job
        
        job.name = name
        job.order = CoreData.maxIntegerValueForEntity(kJobEntity, attributeName: kJobOrderAttribute) + 1
        CoreData.sharedInstance.saveContext()
        
        return job
    }
    
    func delete() {
        CoreData.sharedInstance.managedObjectContext?.deleteObject(self)
        CoreData.sharedInstance.saveContext()
    }
    
    // "Database Trigger". - Won't be using this anyway.
    // Will save comes with certain issues, e.g. the fact that it will recurse into an infinite loop if built like option 1.
    // Option 2 will get around it but looks a little clunky to be honest.
    // Option 3 I need to figure out. Try to receive NSManagedObjectContextWillSaveNotification and set values in there. 

    // Option 2
    /*
    override func willSave() {
        super.willSave()

        if let index = find(jobDidSaveArray, self) {
            jobDidSaveArray.removeAtIndex(index)
        } else {
            jobDidSaveArray.append(self)
            if inserted {
                self.order = CoreData.maxIntegerValueForEntity(kJobEntity, attributeName: kJobOrderAttribute) + 1
            }
        }
    }
    */
    // Option 1
//    override func willSave() {
//        super.willSave()
//        
//        if inserted {
//            //get current max order, increment by one and set job attribute
//            self.order = CoreData.maxIntegerValueForEntity(kJobEntity, attributeName: kJobOrderAttribute) + 1
//        }
//    }
}