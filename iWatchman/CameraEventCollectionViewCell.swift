//
//  CameraEventCollectionViewCell.swift
//  iWatchman
//
//  Created by Hashan Godakanda on 3/23/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import Foundation
import UIKit

class CameraEventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cameraNameLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    var associatedEvent: Event?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 4.5
        clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCellForNotification(notification:)), name: NSNotification.Name.init("DOWNLOADED_THUMBNAIL"), object: DataManager.sharedInstance)
        
        addShadow()
    }
    
    func addShadow() {
        contentView.layer.cornerRadius = 4.5
        contentView.clipsToBounds = true
        contentView.backgroundColor = try! UIColor.init(netHex: 0xF1F1F1)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize.init(width: 0, height: 2)
        layer.shadowPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.masksToBounds = false
        backgroundColor = UIColor.clear
    }
    
    func configureCell(_ event: Event) {
        associatedEvent = event
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        let dateString = dateFormatter.string(from: event.eventDate as Date)
        
        dateLabel.text = dateString
        //cameraNameLabel.text = event.cameraName
        //thumbnailImageView.image =
        
        
        switch event.confidence {
            case 85..<90:
                colorView.backgroundColor = try! UIColor.init(netHex: 0xff9900)
            case 90..<95:
                colorView.backgroundColor = try! UIColor.init(netHex: 0xff471a)
            case 95...100:
                colorView.backgroundColor = try! UIColor.init(netHex: 0xb30000)
            default:
                colorView.backgroundColor = try! UIColor.init(netHex: 0xff9900)
        }
        
        calendarImageView.image = calendarImageView.image!.withRenderingMode(.alwaysTemplate)
        calendarImageView.tintColor = UIColor.white
        
        cameraImageView.image = cameraImageView.image!.withRenderingMode(.alwaysTemplate)
        cameraImageView.tintColor = UIColor.white
    }
    
    func updateThumbnail(event: Event) {
        if let thumbnailImage = event.eventThumbnail {
            thumbnailImageView.image = UIImage(data: thumbnailImage as Data)
        }
    }
    
    func updateCellForNotification(notification: NSNotification) {
        if let event = notification.userInfo?["event"] {
            if let myEvent = associatedEvent {
                if myEvent.remoteID == (event as! Event).remoteID {
                    DispatchQueue.main.async { [weak self]
                        () -> Void in
                            self?.updateThumbnail(event: event as! Event)
                        }
                }

            }
        }
    }
}
