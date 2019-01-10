//
//  DefaultManager.swift

//
//  Created by Gaurav Prakash on 01/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
class DefaultManager{
    static let loggedInKey = "IsLoggedIn"
    static let userDataKey = "loginData"
    static let defaults = UserDefaults.standard
    static let sharedInstance = DefaultManager()
    var loginData: UserData?
    class func setUserData(value: UserData){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            DefaultManager.defaults.set(encoded, forKey: userDataKey)
            DefaultManager.defaults.synchronize()
        }
        DefaultManager.sharedInstance.loginData = value
    }
    func getUserdata() -> UserData?{
        if loginData != nil {
            return  loginData!
        }
        else{
            do {
                let decoder = JSONDecoder()
                loginData = try decoder.decode(UserData.self, from: DefaultManager.defaults.data(forKey: DefaultManager.userDataKey)!) as? UserData
               }catch { print(error) }
            
            return loginData!
        }
    }
    
    class func setLogged(value:Bool){
        DefaultManager.defaults.set(value, forKey: loggedInKey)
        DefaultManager.defaults.synchronize()
    }

    
    class func getIsLoggedIn() -> Bool {
        return DefaultManager.defaults.bool(forKey: loggedInKey)
    }
}
