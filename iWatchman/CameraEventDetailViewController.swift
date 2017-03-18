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

class CameraDetailViewController: UIViewController {

    @IBOutlet weak private var titleNavigationItem: UINavigationItem!
    @IBOutlet weak private var cameraNameLabel: UILabel!

    @IBOutlet weak var videoThumbnailView: UIImageView!
    
    var eventName : String {
        get {
            if let title = titleNavigationItem.title {
                return title
            } else {
                return ""
            }
        }
        
        set {
            titleNavigationItem.title = newValue
        }
    }

//    var cameraName : String {
//        get {
//            if let title = cameraNameLabel.text {
//                return title
//            } else {
//                return ""
//            }
//        }
//        
//        set {
//            cameraNameLabel.text = newValue
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVideoThumbnail()
    }

    @IBAction func playVideo(_ sender: AnyObject) {
        let videoURL: URL = Bundle.main.url(forResource: "X1qIijvAk2Q", withExtension: "mp4")!
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func setVideoThumbnail() {
        let videoURL: URL = Bundle.main.url(forResource: "X1qIijvAk2Q", withExtension: "mp4")!
        let asset = AVAsset(url: videoURL)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        let assetGeneratorCompletionHandler: AVAssetImageGeneratorCompletionHandler = {(requestedTime, image, actualTime, result, error ) -> Void in
            
            if let img = image {
                self.videoThumbnailView.image = UIImage(cgImage: img);
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
