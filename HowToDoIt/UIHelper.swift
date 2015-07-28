//
//  UIHelper.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 26/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import UIKit
import Foundation

class UIHelper {
    
    //MARK: - Helper functions
    
    //convenience function to call delayOnQueue with pre-selected main queue
    static func delayOnMainQueue(delay: NSTimeInterval, callback: () -> Void) {
        UIHelper.delayOnQueue(delay, queue: dispatch_get_main_queue(), callback: callback)
    }
    
    static func delayOnQueue(delay: NSTimeInterval, queue: dispatch_queue_t, callback: () -> Void) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, queue, callback)
    }
    
    //MARK: - Functions displaying UI Components
    static func singleTextFieldDialogWithTitle(title: String, message: String, placeholder: String, textFieldValue: String, okLabel: String, cancelLabel: String, callback: (text:String) -> Void) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = placeholder
            textField.text = textFieldValue
        }
        
        let okAction = UIAlertAction(title: okLabel, style: .Default) { (action) -> Void in
            if let textField = controller.textFields?.first as? UITextField where !textField.text.isEmpty {
                callback(text: textField.text)
            }
        }
        
        let cancelAction = UIAlertAction(title: cancelLabel, style: .Cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        return controller
    }
    
    static func dialogWithTitle(title: String, message: String, okLabel: String, cancelLabel: String, callback: () -> Void) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: okLabel, style: .Default) { (action) -> Void in
            callback()
        }
        
        let cancelAction = UIAlertAction(title: cancelLabel, style: .Cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        return controller
    }
}