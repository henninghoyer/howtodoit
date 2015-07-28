//
//  JobTableViewCell.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 10/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    var job:Job! {//implicit unwrapped optional
        didSet {
            nameButtonOutlet.setTitle(job.name + " order:\(job.order)", forState: .Normal)
//            nameButtonOutlet.setTitle(job.name, forState: .Normal)
        }
    }
    
    @IBOutlet weak var nameButtonOutlet: UIButton!
    @IBOutlet weak var progressCircleImageViewOutlet: UIImageView!

    @IBAction func nameButtonAction(sender: AnyObject) {
//        println(__FILE__.lastPathComponent + " [\(__LINE__)]: " + __FUNCTION__)
        editJob(job)
    }
    
    func editJob(job:Job) {
        let title = NSLocalizedString("titleEditJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Edit Job", comment: "Job Edit Title View Controller Title")
        let placeholder = NSLocalizedString("placeholderEditJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Job", comment: "Placeholder for job edit dialog")
        let message = NSLocalizedString("messageEditJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Change job name. Don't delete all characters though :)", comment: "Message for job edit dialog")
        let ok = NSLocalizedString("okButtonEditJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Ok", comment: "Ok Button in job edit dialog")
        let cancel = NSLocalizedString("cancelButtonEditJobDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "Cancel button in job edit dialog")
        
        //weak self essentially helps to deal with garbage collection. If we just use 'self in line 66 (self.addJob...) then we would have a reference to the JobTable View Controller which would thus never be discarded from memory. At least not cleanly. A weak reference will allow it to be removed from memory without any errors. As a consequence, we have to treat self, in the context of a weak self, as an optional. Hence the '?' in line 66.
        let dialog = UIHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: job.name, okLabel: ok, cancelLabel: cancel) { [weak self] (text) -> Void in
            
            job.name = text
            CoreData.sharedInstance.saveContext()
        }
        
        viewController?.presentViewController(dialog, animated: true, completion: nil)
        //don't necessarily need 'self'
//        self.viewController?.presentViewController(dialog, animated: true, completion: nil)
    }
    
    func disableNameButton() {
        nameButtonOutlet.enabled = false
    }
    
    func enableNameButton () {
        nameButtonOutlet.enabled = true
    }
}
