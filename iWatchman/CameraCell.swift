//
//  CameraCell.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 2/19/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit

class CameraCell: UITableViewCell {

    @IBOutlet weak private var cellNameLabel: UILabel!
    
    var cameraName : String {
        get {
            if let cameraName = cellNameLabel.text {
                return cameraName
            } else {
                return ""
            }
        }
        set {
            cellNameLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
