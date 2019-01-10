//
//  Utils.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 01/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import UIKit

enum Storyboards{
    case MAIN
    case LOGIN
    case HOME
    case DASHBOARD
    case SUGGESTION
    
    var storyBoard : UIStoryboard {
        switch self {
        case .MAIN:
            return UIStoryboard(name: "Main", bundle: nil)
        case .LOGIN:
            return UIStoryboard(name: "Login", bundle: nil)
        case .HOME:
            return UIStoryboard(name: "Home", bundle: nil)
        case .DASHBOARD:
            return UIStoryboard(name: "Dashboard", bundle: nil)
        case .SUGGESTION:
            return UIStoryboard(name: "Suggestion", bundle: nil)
        }
    }
}

enum HomeScreenType{
    case DEFAULT
    case SHARE
    case HOME
    case VALET
}

enum ContactType{
    case SUGGESTION
    case CONTACTUS
}

enum UserCase{
    case LOGIN
    case SIGNUP
}


