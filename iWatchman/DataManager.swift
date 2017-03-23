//
//  DataManager.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 3/18/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import RealmSwift
import Foundation
import Alamofire

class DataManager {
    
    private init() {}
    
    static let sharedInstance: DataManager  = DataManager()
    
    let realm = try! Realm()
    
    let rootURL: URL = URL(string: "http://104.196.62.42:8080/api/")!
    
    // MARK: Pull to refresh
    
    func reloadData(completionHandler: @escaping () -> Void) {
        
        let url = URL(string: "getAllEvents/", relativeTo: rootURL)
        
        Alamofire.request(url!).responseJSON(completionHandler: {
            response in
            
            if let events = response.result.value as? [Dictionary<String, Any>] {
                print(events)
                
                // create dateFormatter with UTC time format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                
                var allEvents: [Event] = Array<Event>()
                
                for event in events {
                    let eventId = String(event["id"] as! Int)
                    let eventDate: Date
                    
                    if let newDate = dateFormatter.date(from: event["date"] as! String) {
                        eventDate = newDate
                    } else {
                        eventDate = Date()
                    }
                    
                    let newEvent = Event(remoteID: eventId, eventDate: eventDate as NSDate)
                    
                    allEvents.append(newEvent)
                }
                
                
                
                DispatchQueue.main.async { [weak self]
                    () -> Void in
                    try! self?.realm.write {
                        self?.realm.add(allEvents, update: true)
                    }
                    completionHandler()
                }
            } else {
                print(response.error)
                print("Error fetching events from server")
            }
        })
    }
    
    // MARK: Push notifications
    
    func registerDeviceTokenForPushNotifications(deviceToken: String) {
        let parameters: Parameters = ["deviceToken": deviceToken]
        let deviceNotificationURL = URL(string: "registerDevice/", relativeTo: rootURL)!
        
        Alamofire.request(deviceNotificationURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { response in
            print(response)
        })
    }
    
    func downloadThumbnails(events: [Event]) {
        for event in events {
            let eventThumbnailURL = URL(string: "getVideoThumbnail/\(event.remoteID)", relativeTo: rootURL)
            Alamofire.request(eventThumbnailURL!).validate().response { response in
                if let error = response.error {
                    print(error)
                } else {
                    event.eventThumbnail = response.data! as NSData
                    
                    DispatchQueue.main.async { [weak self]
                        () -> Void in
                        try! self?.realm.write {
                            self?.realm.add(event, update: true)
                        }
                    }
                    
                    // TODO: Fire a notification saying the image is now available
                    // TODO: Write to file and store url of file
                }
            }
        }
    }
    
    func downloadThumbnail(event: Event, completionHandler: @escaping (_ thumbnailData: NSData?) -> Void) {
        let eventThumbnailURL = URL(string: "getVideoThumbnail/\(event.remoteID)", relativeTo: rootURL)
        
        Alamofire.request(eventThumbnailURL!).validate().response { response in
            if let error = response.error {
                print(error)
                completionHandler(nil)
            } else {
                completionHandler(response.data! as NSData)
            }
        }
    }
        
        
    
    
    
    
    
    

}
