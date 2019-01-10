//
//  LoginVC.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 31/10/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit
import RxSwift
import PinCodeTextField
import IQKeyboardManagerSwift

class LoginVC: UIViewController {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameField: TVTextField!
    @IBOutlet weak var contactField: TVTextField!
    @IBOutlet weak var emailField: TVTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    var loginModel: LoginModel = LoginModel()
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var entryPin: PinCodeTextField!
    var disposeBag = DisposeBag()
    var parkingrequest: Parking!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTheme()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    private func setUpTheme(){
        [nameField, emailField].forEach {
            $0?.isHidden = true
        }
        pinView.keyboardDistanceFromTextField = 40.0
        entryPin.delegate = self
        loginButton.tintColor = .black
        signUpButton.tintColor = Theme.Color.accentColor
        loginModel.usercase = UserCase.LOGIN
        pinView.isHidden = true
        self.parentView.applyCornerToBorder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    @IBAction func nextClicked(_ sender: UIButton) {
        if pinView.isHidden == true{
            if loginModel.checkLogin().0{
              pinView.isHidden = false
            }
        else{
            self.view.makeToast(loginModel.checkLogin().1)
        }
        }
        else{
        switch loginModel.usercase!{
        case .LOGIN:
        if !pinView.isHidden && loginModel.pin != nil && !loginModel.pin.isEmpty{
           self.showLoader(message: "Logging ..")
            var dictionary = [String:Any]()
            dictionary["mobile"] = loginModel.number
            dictionary["pin"] = loginModel.pin
            parkingrequest = .LOGIN(dictionary)
            handleLoginRequest()
        }
        else{
             print("condition not match")
            }
        case .SIGNUP:
            if !pinView.isHidden && loginModel.pin != nil && !loginModel.pin.isEmpty{
                self.showLoader(message: "Signing up..")
                var dictionary = [String:Any]()
                dictionary["mobile"] = loginModel.number
                dictionary["email"] = loginModel.email
                dictionary["name"] = loginModel.name
                dictionary["pin"] = loginModel.pin
                parkingrequest = .REGISTER(dictionary)
                handleLoginRequest()
        }
            else{
                print("condition not match")
            }
        }
    }
    }
    
    fileprivate func navigateView(){
        if let frontVC = Storyboards.DASHBOARD.storyBoard.instantiateViewController(withIdentifier: "Dashboard") as? UINavigationController, let rearVC = Storyboards.HOME.storyBoard.instantiateViewController(withIdentifier: "LeftMenuVC") as? LeftMenuVC{
            if let swRevealVC = SWRevealViewController(rearViewController: rearVC, frontViewController: frontVC){
                self.navigationController?.pushViewController(swRevealVC, animated: true)
            }
        }
    }
    
    func handleLoginRequest(){
        ParkingAPIProvider.rx.request(parkingrequest).subscribe( {event in
            switch event{
            case .success(let response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                if let dictionary = json as? [String: Any]{
                    if let errorCode = dictionary["status"] as? Int, errorCode == 1{
                        do {
                            let decoder = JSONDecoder()
                            let loginData = try decoder.decode(LoginData.self, from: response.data)
                            DefaultManager.setUserData(value: loginData.data![0])
                            DefaultManager.setLogged(value: true)
                            self.hideLoader(completion: {
                                self.navigateView()
                            })
                        }catch { print(error) }
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
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        var dictionary = [String:Any]()
        if DefaultManager.getIsLoggedIn(){
            dictionary["mobile"] = DefaultManager.sharedInstance.getUserdata()?.mobile
            ParkingAPIProvider.rx.request(.FORGOTPASSWORD(dictionary)).subscribe( {event in
                switch event{
                case .success(let response):
                    let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                    if let dictionary = json as? [String: Any]{
                        if let errorCode = dictionary["status"] as? Int, errorCode == 1{
                            self.view.makeToast("Password sent to your registered email")
                        }
                        else{
                            self.view.makeToast(dictionary["message"] as? String)
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
        else{
            self.view.makeToast("No user found")
        }
      
        
    }
    
    @IBAction func flowControl(_ sender: UIButton) {
        switch sender.tag{
        case 10:
            UIView.animate(withDuration: 0.5) {
                self.lineView.frame = CGRect(x: self.loginButton.frame.origin.x, y: self.loginButton.frame.maxY, width: self.loginButton.frame.size.width, height: 3)
            }
            pinView.isHidden = (loginModel.usercase == UserCase.SIGNUP) ? true : false
            sender.tintColor = .black
            signUpButton.tintColor = Theme.Color.accentColor
            [nameField, emailField].forEach {
                $0?.isHidden = true
            }
            loginModel.usercase = UserCase.LOGIN
            forgotPassword.isHidden = false
        
        case 11:
            UIView.animate(withDuration: 0.5) {
                self.lineView.frame = CGRect(x: self.signUpButton.frame.origin.x, y: self.signUpButton.frame.maxY, width: self.signUpButton.frame.size.width, height: 3)
            }
        
            [nameField, emailField].forEach {
                $0?.isHidden = false
            }
            pinView.isHidden = (loginModel.usercase == UserCase.LOGIN) ? true : false
            loginButton.tintColor = Theme.Color.accentColor
            sender.tintColor = .black
            loginModel.usercase = UserCase.SIGNUP
            forgotPassword.isHidden = true
          
        default:break
        }
    }
    
}

extension LoginVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameField:
            textField.keyboardType = .default
        case contactField:
            textField.keyboardType = .numberPad
        case emailField:
            textField.keyboardType = .emailAddress
        default:
            break
        }
    }
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case nameField:
    return contactField.becomeFirstResponder()
    case contactField:
    switch loginModel.usercase!{
    case .LOGIN:
    return textField.resignFirstResponder()
    case .SIGNUP:
    return emailField.becomeFirstResponder()
    }
    case emailField:
    return textField.resignFirstResponder()
    default:
    break
    }
    return false
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case nameField:
                 loginModel.name = textField.text ?? ""
            case contactField:
                loginModel.number = textField.text ?? ""
            case emailField:
                loginModel.email = textField.text ?? ""
            default:
                break
            }
            
        }
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            return true
        }
    
}

extension LoginVC: PinCodeTextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        switch textField {
        case entryPin:
            textField.keyboardType = .numberPad
            NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
        default:
            break
        }
    }
    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
        switch textField {
        case entryPin:
            NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
            loginModel.pin = textField.text ?? ""
        default:
            break
        }
    }

}
class LoginModel{
    var name:String! = ""
    var number:String! = ""
    var email:String! = ""
    var pin:String! = ""
    var usercase:UserCase! = UserCase.LOGIN
    
    init(){}
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if self.name != nil && !self.name.isEmpty{
            dictionary["name"] = self.name
        }
        if self.number != nil && !self.number.isEmpty {
            dictionary["Number"] = self.number
        }
        if self.email != nil && !self.email.isEmpty{
            dictionary["Email"] = self.email
        }
        if self.pin != nil && !self.pin.isEmpty{
            dictionary["Pin"] = self.pin
        }
        return dictionary
    }
    
    func checkLogin() -> (Bool, String){
        switch usercase! {
        case .LOGIN :
            if self.number.isEmpty{
               return(false, "please enter your number")
            }
            else if self.number.count != 10{
                return(false, "please enter 10 digit number")
            }
            else{
                return(true, "")
            }
        case.SIGNUP :
            if self.name.isEmpty{
                return(false, "please enter your name")
            }
            else if self.number.isEmpty{
                return(false, "please enter your number")
            }
            else if self.number.count != 10{
                return(false, "please enter 10 digit number")
            }
            else if self.email.isEmpty{
                return(false, "please enter your email")
            }
            else if !self.email.isValidEmail(){
                return (false, "please enter valid email")
            }
            else{
                return(true, "")
            }
        }
    }
    
    
}
