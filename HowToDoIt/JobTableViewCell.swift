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
            //nameButtonOutlet.setTitle(job.name + " order:\(job.order)", forState: .Normal)
            nameButtonOutlet.setTitle(job.name, forState: .Normal)
        }
    }
    
    @IBOutlet weak var nameButtonOutlet: UIButton!
    @IBOutlet weak var progressCircleImageViewOutlet: UIImageView!

    @IBAction func nameButtonAction(sender: AnyObject) {
        println(__FILE__.lastPathComponent + " [\(__LINE__)]: " + __FUNCTION__)
    }
}
