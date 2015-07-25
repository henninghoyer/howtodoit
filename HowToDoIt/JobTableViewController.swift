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

    private var _fetchedResultsController:NSFetchedResultsController!
    private var fetchedResultsController:NSFetchedResultsController! {
        if _fetchedResultsController != nil {return _fetchedResultsController}
        
        let request = NSFetchRequest(entityName: kJobEntity)

        //request needs to be sorted
        request.sortDescriptors = [NSSortDescriptor(key: kJobOrderAttribute, ascending: true)]
        
        //initialize _fetchedResultsController
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        //set delegate to monitor for changes (observer?)
        _fetchedResultsController.delegate = self
    
        //not catching error since if this fails then our database is corrupted and the app won't work anyway.
        _fetchedResultsController.performFetch(nil)
        
        return _fetchedResultsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title of the view
        title = NSLocalizedString("titleJobTableViewController", tableName: nil, bundle: NSBundle.mainBundle(), value: "Job", comment: "This is the navigation bar title")
        
        // Add an "Add" Button to the right side of the navigation bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addJob:")
        navigationItem.setRightBarButtonItem(addButton, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Job Table View Handlers
    func addJob(sender:UIBarButtonItem) {
        
        // When add gets pressed we need an alert to come up and ask for input. At least for now.
        // Dialog itself
        let dialog = UIAlertController(title: "New Job", message: "Please add the name of the Job you would like to add.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Buttons to be added to dialog
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            println("OK pressed.")
            
            if let textField = dialog.textFields?.first as? UITextField where !textField.text.isEmpty {
                Job.createJobWithName(textField.text)
            }
        }
        let jobTitle = dialog.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Jobname"
        }
        
        // Add actions to dialog
        dialog.addAction(cancel)
        dialog.addAction(ok)
        
        // Show dialog
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let job = fetchedResultsController.objectAtIndexPath(indexPath) as! Job
            job.delete()
        }
    }
}
