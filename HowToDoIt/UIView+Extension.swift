//
//  UIView+Extension.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 27/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    /*
     * Traverse the responder chain to find the first available UIViewController
     */
    //this is what we actually call from a UIView object. object.viewController
    var viewController:UIViewController? {
        return traverseResponderChainForViewController()
    }
    
    private func traverseResponderChainForViewController() -> UIViewController? {
        if let responder = nextResponder() as? UIViewController {
            return responder
        }
        
        if let responder = nextResponder() as? UIView {
            return responder.traverseResponderChainForViewController()
        }
        
        return nil
    }
    
}