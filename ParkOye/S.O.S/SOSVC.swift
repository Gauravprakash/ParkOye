//
//  SOSVc.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 19/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

class SOSVC: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var hospital: UIImageView!
    @IBOutlet weak var ambulance: UIImageView!
    @IBOutlet weak var fire: UIImageView!
    @IBOutlet weak var police: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if  self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        hospital.image = #imageLiteral(resourceName: "hospital").tint(with: .white)
        police.image = #imageLiteral(resourceName: "police").tint(with: .white)
        fire.image = #imageLiteral(resourceName: "fire").tint(with: .white)
        ambulance.image = #imageLiteral(resourceName: "ambulance").tint(with: .white)
        
    }

    @IBAction func handlingServices(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            print("\(sender.tag)")
        case 102:
            makePhoneCall(phone: "100")
        case 103:
            makePhoneCall(phone: "101")
        case 104:
            makePhoneCall(phone: "102")
        default:
            break
        }
        
    }
    
    private func makePhoneCall(phone:String){
        if let phoneCallURL:URL = URL(string: "tel:\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: Theme.appName, message: "Are you sure you want to call \n\(phone)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                
                })
                
                let noPressed = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    

}
