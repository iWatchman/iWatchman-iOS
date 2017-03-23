//
//  AllCameraEventsViewController.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 2/18/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit
import RealmSwift

class AllCameraEventsViewController: UITableViewController {
    
    let events = try! Realm().objects(Event.self).sorted(by: ["eventDate"])
    
    var sectionNames: [String] {
        return Set(events.value(forKeyPath: "eventDay") as! [String]).sorted()
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(showEventForNotification(notification:)), name: NSNotification.Name.init("SHOW_EVENT_DETAIL"), object: nil)
        
        let realm = try! Realm()
        if realm.isEmpty {
            try! realm.write {
                realm.add(Event(remoteID: "1", eventDateString: ""))
                realm.add(Event(remoteID: "2", eventDateString: ""))
            }
        }
        
        // 
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        DataManager.sharedInstance.reloadData { [weak self]
            () -> Void in
            self?.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.filter("eventDay == %@", sectionNames[section]).count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! CameraEventCell
        
        let currDate = events.filter("eventDay == %@", sectionNames[indexPath.section])[indexPath.row].eventDate
        
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .none
        
        cell.cameraName = dateFormatter.string(from: currDate as Date)

        return cell
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCameraDetail" {
            if sender is Event {
                let controller = segue.destination as! CameraEventDetailViewController
                controller.event = sender as? Event
            } else if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! CameraEventDetailViewController
                controller.event = events.filter("eventDay == %@", sectionNames[indexPath.section])[indexPath.row]
            }
        }
    }
    
    func showEventForNotification(notification: NSNotification) {
        performSegue(withIdentifier: "showCameraDetail", sender: notification.object)
    }

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */



}

