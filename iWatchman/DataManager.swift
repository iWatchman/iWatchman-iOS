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
    
//    let rootURL: URL = URL(string: "https://test-project-156600.appspot.com/api/registerDevice/")!
    
    let rootURL = URL(string: "http://a1e64b24.ngrok.io/")!
    
    // MARK: Pull to refresh
    
    func reloadData(completionHandler: @escaping () -> Void) {
        
        let url = URL(string: "http://a1e64b24.ngrok.io/events")
        
        Alamofire.request(url!).responseJSON(completionHandler: {
            response in
            
            if let events = response.result.value as? [Dictionary<String, Any>] {
                print(events)
                
                // create dateFormatter with UTC time format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                
                var allEvents: [Event] = Array<Event>()
                
                for event in events {
                    let eventId = String(event["id"] as! Int)
                    let eventDate = dateFormatter.date(from: event["date"] as! String)!
                    
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
                print("Error fetching events from server")
            }
        })
    }
    
    // MARK: Push notifications
    
    func registerDeviceTokenForPushNotifications(deviceToken: String) {
        let parameters: Parameters = ["deviceToken": deviceToken]
        
        Alamofire.request(rootURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { response in
            print(response)
        })
    }
        
        
    
    
    
    
    
    

}
