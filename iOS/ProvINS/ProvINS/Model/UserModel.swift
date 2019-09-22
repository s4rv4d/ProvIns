//
//  UserModel.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    //MARK: - Varibles
    var email:String?
    var password:String?
    var devices:[CardModel]?
    
    //MARK: - Initializer
    init(email:String, password:String, devices:[CardModel]? = nil) {
        self.email = email
        self.password = password
        self.devices = devices
    }
    
    //MARK: - Class functions
    class func logout() {
        //logout logic here
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        UserDefaults.standard.removeObject(forKey: userObj)
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        appDelegate.window?.rootViewController = mainView
    }
    
    class func displayEmail() -> String?{
        if let userObjectStored = UserDefaults.standard.object(forKey: "User") as? User{
            let userObj = userObjectStored
            return userObj.email
        }
        return nil
    }
    
    //MARK: - Functions
    func loginWithEmail(email:String, password:String) {
        //server logic here with parameters
    }
    
    func save(userResponse: [String:Any]){
        //userdefaullts setup
        UserDefaults.standard.set(userResponse, forKey: userObj)
    }
}

struct UserResponse {
    var _id: String
    var email: String
    var password: String
    var devices: [CardModel]? = []
    var __v:Int
    
    init(_id:String = "", email:String = "", password:String = "", devices:[CardModel] = [], __v:Int = 0) {
        self._id = _id
        self.email = email
        self.password = password
        self.devices = devices
        self.__v = __v
    }
    
}
