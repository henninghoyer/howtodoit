//
//  JobTableViewController.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 10/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import UIKit
import CoreData

class JobTableViewController: UITableViewController {

    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        
        let request = NSFetchRequest(entityName: kJobEntity)

        //request needs to be sorted
        request.sortDescriptors = [NSSortDescriptor(key: kJobOrderAttribute, ascending: true)]
        
        //initialize _fetchedResultsController
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        //set delegate to monitor for changes (observer?)
        fetchedResultsController.delegate = self
    
        //not catching error since if this fails then our database is corrupted and the app won't work anyway.
        fetchedResultsController.performFetch(nil)
        
        return fetchedResultsController
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title of the view
        title = NSLocalizedString("titleJobTableViewController", tableName: nil, bundle: NSBundle.mainBundle(), value: "Job", comment: "This is the navigation bar title")
        
        // Add an "Add" Button to the right side of the navigation bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addJob:")
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAll")
        navigationItem.setRightBarButtonItems([addButton,editButtonItem(),deleteAllButton], animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Bar Button Item Actions
    func addJob(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleCreateJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Create Job", comment: "Job Creation Title View Controller Title")
        let placeholder = NSLocalizedString("placeholderCreateJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Job", comment: "Placeholder for job creation dialog")
        let message = NSLocalizedString("messageCreateJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Enter a job name. This dialog will show up again until you press cancel so that you can easily add multiple jobs.", comment: "Message for job creation dialog")
        let ok = NSLocalizedString("okButtonCreateJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Ok", comment: "Ok Button in job creation dialog")
        let cancel = NSLocalizedString("cancelButtonCreateJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "Cancel button in job creation dialog")
        
        //weak self essentially helps to deal with garbage collection. If we just use 'self in line 66 (self.addJob...) then we would have a reference to the JobTable View Controller which would thus never be discarded from memory. At least not cleanly. A weak reference will allow it to be removed from memory without any errors. As a consequence, we have to treat self, in the context of a weak self, as an optional. Hence the '?' in line 66.
        let dialog = UIHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: "", okLabel: ok, cancelLabel: cancel) { [weak self] (text) -> Void in
            
            Job.createJobWithName(text)
            
            UIHelper.delayOnMainQueue(0.3) { () -> Void in
                self?.addJob(sender)
            }
        }
        
        presentViewController(dialog, animated: true, completion: nil)
    }

    func deleteAll() {
        let title = NSLocalizedString("titleDeleteAllDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Delete all Jobs", comment: "Job Deletion Title View Controller Title")
        let message = NSLocalizedString("messageDeleteAllDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Are you sure you want to delete all jobs?", comment: "Message for job deletion dialog")
        let ok = NSLocalizedString("okButtonDeleteAllDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Yes, DELETE all jobs.", comment: "Ok Button in job creation dialog")
        let cancel = NSLocalizedString("cancelDeleteAllJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "Cancel button in job creation dialog")
        
        //weak self essentially helps to deal with garbage collection. If we just use 'self in line 66 (self.addJob...) then we would have a reference to the JobTable View Controller which would thus never be discarded from memory. At least not cleanly. A weak reference will allow it to be removed from memory without any errors. As a consequence, we have to treat self, in the context of a weak self, as an optional. Hence the '?' in line 66.
        let dialog = UIHelper.dialogWithTitle(title, message: message, okLabel: ok, cancelLabel: cancel) { 
            Job.deleteAll()
        }
        presentViewController(dialog, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return fetchedResultsController.sections?.count ?? 0 //nil-coalescing operator
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return (fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kJobTableViewCell, forIndexPath: indexPath) as! JobTableViewCell
        
        cell.job = fetchedResultsController.objectAtIndexPath(indexPath) as! Job

        return cell
    }
    
    //this is what you need to implement swipe to delete "commitEditingStyle"
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let job = fetchedResultsController.objectAtIndexPath(indexPath) as! Job
            job.delete()
        }
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        if let jobCell = tableView.cellForRowAtIndexPath(indexPath) as? JobTableViewCell {
            jobCell.disableNameButton()
        }
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if let jobCell = tableView.cellForRowAtIndexPath(indexPath) as? JobTableViewCell {
            jobCell.enableNameButton()
        }
    }
    
    //simply overriding will enable ability to move items in a table view. Logic not included :)
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //if sourceindex and destinationindex are the same, then nothing has happened.
        if sourceIndexPath.row == destinationIndexPath.row { return }
        
        let source = fetchedResultsController.objectAtIndexPath(sourceIndexPath) as! NSManagedObject
        let dest = fetchedResultsController.objectAtIndexPath(destinationIndexPath) as! NSManagedObject
        
        CoreData.move(kJobEntity, orderAttributeName: kJobOrderAttribute, source: source, toDestination: dest)
    }
}
