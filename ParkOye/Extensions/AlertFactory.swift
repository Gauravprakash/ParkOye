//
//  AlertFactory.swift
//  FCmIndia
//
//  Created by Hemant Singh on 13/04/17.
//  Copyright © 2017 Santosh Kumar. All rights reserved.
//

import Foundation
import UIKit

class AlertFactory{

    static func defaultAlert(caller: UIViewController?) {
        let alert = UIAlertController(title: "Something went wrong", message: "Please try again later", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        let deviceIdiom = (UIApplication.shared.delegate as? AppDelegate)?.deviceIdiom
        switch deviceIdiom! {
        case .pad:
          alert.popoverPresentationController?.sourceView = caller?.view
          alert.popoverPresentationController?.sourceRect = CGRect(x: (caller?.view.bounds.midX)!, y: (caller?.view.bounds.midY)!, width: 0, height: 0)
          alert.popoverPresentationController?.permittedArrowDirections = []
          caller?.present(alert, animated: true, completion: nil)
            
        case .phone:
            caller?.present(alert, animated:true, completion: nil)
        default:
            break
        }
//        caller?.present(alert, animated:true, completion: nil)
    }
    
    static func alert(caller: UIViewController?, msg: String){
        let alert = UIAlertController(title: Theme.appName, message: msg, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        let deviceIdiom = (UIApplication.shared.delegate as? AppDelegate)?.deviceIdiom
        switch deviceIdiom! {
        case .pad:
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = caller?.view
                popoverController.sourceRect = (caller?.view.bounds)!
                caller?.present(alert, animated: true, completion: nil)
            }
        case .phone:
            caller?.present(alert, animated:true, completion: nil)
        default:
            break
        }
        //caller?.present(alert, animated:true, completion: nil)
    }
    
    static func successAlert(caller: UIViewController?, msg: String) {
        let alert = UIAlertController(title: "Success!", message: msg, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        caller?.present(alert, animated:true, completion: nil)
    }
}
