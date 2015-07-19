//
//  JobTableViewController.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 10/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import UIKit

class JobTableViewController: UITableViewController {

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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kJobTableViewCell, forIndexPath: indexPath) as! JobTableViewCell
        cell.nameButtonOutlet.setTitle("Row \(indexPath.row)", forState: UIControlState.Normal)
        return cell
    }
}
