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
    
    let videoURLRoot: NSURL = NSURL(string: "https://test-project-156600.appspot.com/api/getVideoClip/")!
    var videoID = "1"
    var videoURL: NSURL? = nil
    
    let myDateFormatter = DateFormatter()
    
    var eventDate : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoURL = NSURL(string: videoID, relativeTo: videoURLRoot as URL)
        
        DispatchQueue.global(qos: .background).async { [weak self]
            () -> Void in
            self?.setVideoThumbnail()
        }
        
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
        let asset = AVAsset(url: videoURL as! URL)
        
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        let assetGeneratorCompletionHandler: AVAssetImageGeneratorCompletionHandler = {(requestedTime, image, actualTime, result, error ) -> Void in
            
            if let img = image {
                
                DispatchQueue.main.async { [weak self]
                    () -> Void in
                    self?.videoThumbnailView.image = UIImage(cgImage: img);
                }
            } else {
                print("Failed to generate thumbnail.")
            }
        }
        
        let thumbnailTime = NSValue(time: CMTimeMultiplyByFloat64(asset.duration, 0.5))
        
        assetGenerator.generateCGImagesAsynchronously(forTimes: [thumbnailTime], completionHandler: assetGeneratorCompletionHandler);
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
