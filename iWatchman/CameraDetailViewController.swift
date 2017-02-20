//
//  CameraDetailViewController.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 2/20/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
