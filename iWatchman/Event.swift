//
//  Event.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 3/18/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit
import RealmSwift

class Event: Object {
    dynamic var remoteID = ""
    dynamic var eventDate = NSDate()
    
    
    convenience init(remoteID: String, eventDate: NSDate) {
        self.init()
        self.remoteID = remoteID
        self.eventDate = eventDate
    }
}
