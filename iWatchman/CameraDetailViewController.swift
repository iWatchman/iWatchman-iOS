//
//  CameraDetailViewController.swift
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
    
    var cameraName : String {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        let videoURL: URL = Bundle.main.url(forResource: "BC9ry2ZoYks", withExtension: "mp4")!
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
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
