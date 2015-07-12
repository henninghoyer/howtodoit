//
//  JobTableViewCell.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 10/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var nameButtonOutlet: UIButton!
    @IBOutlet weak var progressCircleImageViewOutlet: UIImageView!

    @IBAction func nameButtonAction(sender: AnyObject) {
        println(__FILE__.lastPathComponent + " [\(__LINE__)]: " + __FUNCTION__)
    }
}
