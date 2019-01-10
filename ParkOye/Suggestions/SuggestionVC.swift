//
//  SuggestionVC.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 01/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit
import RxSwift

class SuggestionVC: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblcontact: UILabel!
    var contactType:ContactType! = ContactType.SUGGESTION
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        if  self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        textView.backgroundColor = UIColor(rgb: 0xF4F5F6)
        
        switch contactType! {
        case .CONTACTUS:
            self.title = "Contact Us"
            self.lblcontact.text = "Contact Us"
        case .SUGGESTION:
            self.title = "Feedback"
            self.lblcontact.text = "Text Your Suggestion"
        }
        self.submitButton.addCornerRadius()
        textView.becomeFirstResponder()
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    @IBAction func submitAction(_ sender: UIButton) {
        self.showLoader(message: "Submitting..")
        var dictionary = [String:Any]()
        dictionary["data"] = textView.text
        switch contactType! {
        case .CONTACTUS:
            dictionary["id"] = "0"
        case .SUGGESTION:
            dictionary["id"] = "1"
        }
        ParkingAPIProvider.rx.request(.CONTACTADMIN(dictionary)).subscribe( {event in
            switch event{
            case .success(let response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                if let dictionary = json as? [String: Any]{
                    if let errorCode = dictionary["status"] as? Int, errorCode == 1{
                        self.hideLoader(completion: {
                            self.view.makeToast(dictionary["data"] as? String ?? dictionary["data"] as? String)
                            self.textView.text = ""
                        })
                    }
                    else{
                        self.hideLoader(completion: {
                            self.view.makeToast(dictionary["message"] as? String)
                        })
                        }
                }
                else{
                    print("Incorrect format response")
                }
            case .error(let err):
                print(err.localizedDescription)
            }
        }).disposed(by: disposeBag)
        }
    
}

