//
//  DataManager.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 3/18/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import RealmSwift
import Foundation

class DataManager {
    
    private init() {}
    
    static let sharedInstance: DataManager  = DataManager()
    
    let realm = try! Realm()
    
    
    // MARK: Pull to refresh
    
    func reloadData(completionHandler: @escaping () -> Void) {
        
        let url = URL(string: "http://localhost:3000/events")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>]
            
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            
            var allEvents: [Event] = Array<Event>()
            
            if let events = json {
                for event in events {
                    let eventId = String(event["id"] as! Int)
                    let eventDate = dateFormatter.date(from: event["date"] as! String)!
                    
                    let newEvent = Event(remoteID: eventId, eventDate: eventDate as NSDate)
                    
                    allEvents.append(newEvent)
                }
            }
            
            DispatchQueue.main.async { [weak self]
                () -> Void in
                try! self?.realm.write {
                    self?.realm.add(allEvents, update: true)
                }
                completionHandler()
            }
            
        }
        
        task.resume()
    }
        
        
    
    
    
    
    
    

}
