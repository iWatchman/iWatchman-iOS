//
//  UIColor+CustomColor.swift
//  iWatchman
//
//  Created by Hashan Godakanda on 3/23/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit

// Source: http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
enum ColorError: Error {
    case invalidRedComponent
    case invalidGreenComponent
    case invalidBlueComponent
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alphaValue: CGFloat) throws {
        if !(red >= 0 && red <= 255) {
            throw ColorError.invalidRedComponent
        } else if !(green >= 0 && green <= 255) {
            throw ColorError.invalidGreenComponent
        } else if !(blue >= 0 && blue <= 255) {
            throw ColorError.invalidBlueComponent
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alphaValue)
    }
    
    convenience init(netHex:Int, alpha:CGFloat = 1.0) throws {
        try! self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alphaValue:alpha)
    }
}
