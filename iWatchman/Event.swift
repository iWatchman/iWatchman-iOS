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
    dynamic var eventDate = NSDate() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            
            eventDay = dateFormatter.string(from: eventDate as Date)
        }
    }
    
    // String representation of day
    // Useful for splitting into sections in a table view
    dynamic var eventDay = ""
    
    convenience init(remoteID: String, eventDate: NSDate) {
        self.init()
        self.remoteID = remoteID
        self.eventDate = eventDate
    }
    
    override static func primaryKey() -> String? {
        return "remoteID"
    }
}
