//
//  AllCameraEventsCollectionViewController.swift
//  iWatchman
//
//  Created by Hashan Godakanda on 3/23/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit
import RealmSwift

class AllCameraEventsCollectionViewController: UICollectionViewController {


    let events = try! Realm().objects(Event.self).sorted(by: ["eventDate"])
    
    var selectedIndexPath: IndexPath?
    
    let reuseIdentifier = "CameraEventCell"
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEventForNotification(notification:)), name: NSNotification.Name.init("SHOW_EVENT_DETAIL"), object: nil)
        
        let realm = try! Realm()
        if realm.isEmpty {
            try! realm.write {
                realm.add(Event(remoteID: "1", eventDateString: ""))
                realm.add(Event(remoteID: "2", eventDateString: ""))
                realm.add(Event(remoteID: "3", eventDateString: ""))
            }
        }
        
        //
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        self.collectionView?.addSubview(refreshControl)
        
        
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 24)
        }
        
        self.collectionView?.register(UINib(nibName: "CameraEventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeaderView")
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        DataManager.sharedInstance.reloadData { [weak self]
            () -> Void in
            self?.collectionView?.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "showCameraDetail", sender: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CameraEventCollectionViewCell
        cell.configureCell(events[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width - 20, height: 250)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCameraDetail" {
            if sender is Event {
                let controller = segue.destination as! CameraEventDetailViewController
                controller.event = sender as? Event
            } else if let indexPath = selectedIndexPath {
                let controller = segue.destination as! CameraEventDetailViewController
                controller.event = events[indexPath.row]
            }
        }
    }
    
    func showEventForNotification(notification: NSNotification) {
        performSegue(withIdentifier: "showCameraDetail", sender: notification.object)
    }
}
