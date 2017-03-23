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
                var allEvents: [Event] = Array<Event>()
                
                for event in events {
                    let newEvent = Event(eventJSON: event)
                    allEvents.append(newEvent)
                }
                
                self.downloadThumbnails(eventIds: allEvents.map {$0.remoteID})
                
                DispatchQueue.main.async { [weak self]
                    () -> Void in
                    try! self?.realm.write {
                        self?.realm.deleteAll()
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
    
    func downloadThumbnails(eventIds: [String]) {
        for eventId in eventIds {
            let eventThumbnailURL = URL(string: "getVideoThumbnail/\(eventId)", relativeTo: rootURL)
            Alamofire.request(eventThumbnailURL!).validate().response { response in
                if let error = response.error {
                    print(error)
                } else {
                    let eventThumbnail = response.data! as NSData
                    let event = Event()
                    event.remoteID = eventId
                    event.eventThumbnail = eventThumbnail
                    
                    NotificationCenter.default.post(name: NSNotification.Name.init("DOWNLOADED_THUMBNAIL"), object: self, userInfo: ["event": event])
                    
                    DispatchQueue.main.async { [weak self]
                        () -> Void in
                        try! self?.realm.write {
                            self?.realm.add(event, update: true)
                        }
                    }
                    
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
