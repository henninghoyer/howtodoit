//
//  CommandTunnel.swift
//  HowToDoIt
//
//  Created by Henning Hoyer on 19/07/15.
//  Copyright (c) 2015 Henning Hoyer. All rights reserved.
//

import Foundation
import CoreData

@objc(CommandTunnel)
class CommandTunnel: NSManagedObject {

    @NSManaged var command: String

}
