//
//  CameraEventDetailViewController.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 2/20/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CameraEventDetailViewController: UIViewController {

    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    
    @IBOutlet weak var videoThumbnailView: UIImageView!
    
    let videoURLRoot: NSURL = NSURL(string: "http://104.196.62.42:8080/api/getVideoClip/")!
    var videoURL: NSURL? = nil
    
    let myDateFormatter = DateFormatter()
    
    var eventDate : Date = Date()
    var eventThumbnail: NSData?
    var event: Event? {
        didSet {
            eventDate = event?.eventDate as! Date
            eventThumbnail = event?.eventThumbnail
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        videoURL = NSURL(string: (event?.remoteID)!, relativeTo: videoURLRoot as URL)
        self.setVideoThumbnail()
        
        // Set Date and Time
        myDateFormatter.dateStyle = .medium
        myDateFormatter.timeStyle = .none
        
        dateValueLabel.text = myDateFormatter.string(from: eventDate)
        
        myDateFormatter.dateStyle = .none
        myDateFormatter.timeStyle = .medium
        timeValueLabel.text = myDateFormatter.string(from: eventDate)
    }

    @IBAction func playVideo(_ sender: AnyObject) {
        let player = AVPlayer(url: videoURL as! URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func setVideoThumbnail() {
        if let thumbnailData = eventThumbnail {
            let image = UIImage(data: thumbnailData as Data)!
            DispatchQueue.main.async {
                self.videoThumbnailView.image = image
            }
        } else {
            DataManager.sharedInstance.downloadThumbnail(event: event!, completionHandler: {(thumbnailData) in
                
                let thumbnail = UIImage(data: thumbnailData as! Data)
                
                DispatchQueue.main.async {
                    self.videoThumbnailView.image = thumbnail
                }
            })
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
