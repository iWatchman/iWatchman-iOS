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
    dynamic var backingEventDate = NSDate()
    
    var eventDate: NSDate {
        get {
            return backingEventDate
        }
        
        set {
            backingEventDate = newValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            
            eventDay = dateFormatter.string(from: eventDate as Date)
        }
    }
    
    // String representation of day
    // Useful for splitting into sections in a table view
    dynamic var eventDay = ""
    
    dynamic var confidence = 0
    dynamic var accuracy = 0
    
    dynamic var eventThumbnail: NSData?
    
    convenience init(remoteID: String, eventDateString: String) {
        self.init()
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        if let newDate = dateFormatter.date(from: eventDateString) {
            eventDate = newDate as NSDate
        } else {
            eventDate = NSDate()
        }
        self.remoteID = remoteID
    }
    
    convenience init(eventJSON: [AnyHashable: Any]) {
        self.init()
        
        self.remoteID = String(eventJSON["id"] as! Int)
        
        // Extract Date
        let eventDateString = eventJSON["date"] as! String
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        if let newDate = dateFormatter.date(from: eventDateString) {
            self.eventDate = newDate as NSDate
        } else {
            self.eventDate = NSDate()
        }
        
        // Accuracy
        
        
//        if let confidenceValue = eventJSON["confidence"] {
//            self.confidence = confidenceValue as! Int
//        }
//        
//        if let accuracyValue = eventJSON["accuracy"] {
//            self.accuracy = accuracyValue as! Int
//        }
    }
    
    override static func primaryKey() -> String? {
        return "remoteID"
    }
}
