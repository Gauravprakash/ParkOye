//
//  Theme.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 31/10/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    static let appName = "MLCP Noida"
    static let googlePlaceKey:String = "AIzaSyDBgUpzooEkxwbmwMPYpWQN4P0bHIatZ8w"
    struct Config{
        static let baseUrl:String = "https://delbt.coxandkings.com"
    }
    struct Color{
        static let cellTextColor = UIColor(rgb: 0xEE8427)
        static let primaryColor = UIColor(rgb:0x459435)
        static let accentColor = UIColor(red: 162/255.0, green: 157/255.0, blue: 142/255.0, alpha: 0.8)
        static let mapColor = UIColor(red: 65/255.0, green: 52/255.0, blue: 58/255.0, alpha: 0.9)
        static let loginView = UIColor(rgb: 0xF4F5F6)
        static let primaryTextColor = UIColor(rgb: 0x78797A)
        static let loginButtonText = UIColor.white
        static let loginButtonBg = UIColor(rgb: 0x79BE31)
    }
  
    struct Strings{
        static let cellIdentifier = "Cell"
        static let appName = "Park Oye"
        static let latValue:String! = "28.569306"
        static let longValue:String! = "77.322000"
        static let priceValue = "30"
        }
}
