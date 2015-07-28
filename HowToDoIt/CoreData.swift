//
//  CoreData.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 10/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import CoreData
import Foundation

//rows 14 + 18-22 will do the trick since we now we won't be accessing this from
//multiple threads. If we were to do just that we'd need a token to pass around.
private var coreDataSharedInstance = CoreData()

class CoreData {
    
    //MARK: - Helper functions
    static func move(entityName:String, orderAttributeName:String, source:NSManagedObject, toDestination:NSManagedObject) {
        if let sourceOrder = source.valueForKey(orderAttributeName)?.integerValue, destinationOrder = toDestination.valueForKey(orderAttributeName)?.integerValue {
            let request = NSFetchRequest(entityName: entityName)
            
            //TODO: This is wrong! Need to make sure this works with my sort order, esp. nspredicate might not be ok.
            if sourceOrder < destinationOrder { //we are moving an item down the list
                request.sortDescriptors = [NSSortDescriptor(key: orderAttributeName, ascending: false)]
                request.predicate = NSPredicate(format: "\(orderAttributeName) > \(sourceOrder) AND \(orderAttributeName) <= \(destinationOrder)")
                if let resultArray = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil) as? [NSManagedObject] {
                    resultArray.map {(object) -> NSManagedObject in
                        object.setValue(object.valueForKey(orderAttributeName)!.integerValue - 1, forKey: orderAttributeName)
                        return object
                    }
                }
            } else if sourceOrder > destinationOrder { //we are moving an item up the list
                request.sortDescriptors = [NSSortDescriptor(key: orderAttributeName, ascending: true)]
                request.predicate = NSPredicate(format: "\(orderAttributeName) >= \(destinationOrder) AND \(orderAttributeName) < \(sourceOrder)")
                if let resultArray = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil) as? [NSManagedObject] {
                    resultArray.map {(object) -> NSManagedObject in
                        object.setValue(object.valueForKey(orderAttributeName)!.integerValue + 1, forKey: orderAttributeName)
                        return object
                    }
                }
            }
            source.setValue(destinationOrder, forKey: orderAttributeName)
            CoreData.sharedInstance.saveContext()
        }
    }
    
    static func minMaxIntegerValueForEntity(entityName:String, attributeName:String, minimum:Bool, predicate:NSPredicate = NSPredicate(value: true)) -> Int {
        
        //create request object and set parameters for fetch
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: attributeName, ascending: minimum)]
        request.fetchLimit = 1
        request.predicate = predicate
        
        // Execute request. If everything works as expected then return an integer value from the retrieved object, if not return 0
        if let object = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil)?.first as? NSManagedObject {
            return object.valueForKey(attributeName)?.integerValue ?? 0
        }
        return 0
    }
    
    // The following are convenience functions, they simply call minMaxIntegerValueForEntity with different values for the minimum parameter
    static func minIntegerValueForEntity(entityName:String, attributeName:String, predicate:NSPredicate = NSPredicate(value: true)) -> Int {
        return minMaxIntegerValueForEntity(entityName, attributeName: attributeName, minimum: true, predicate: predicate)
    }

    static func maxIntegerValueForEntity(entityName:String, attributeName:String, predicate:NSPredicate = NSPredicate(value: true)) -> Int {
        return minMaxIntegerValueForEntity(entityName, attributeName: attributeName, minimum: false, predicate: predicate)
    }

    //MARK: Shared Instance Creation - Singleton Pattern
    class var sharedInstance: CoreData{
        return coreDataSharedInstance
    }
    
    private init () {}
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.henninghoyer.HowToDoIt" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("HowToDoIt", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        if let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kAppGroup) {
            
            let url = containerURL.URLByAppendingPathComponent("HowToDoIt.sqlite")
            var error: NSError? = nil
            var failureReason = "There was an error creating or loading the application's saved data."
            if coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
//                coordinator = nil
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        } else {
            NSLog("Cannot create persistentStoreCoordinator")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}