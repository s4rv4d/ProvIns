//
//  UserModel.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation

class User {
    
    //MARK: - Varibles
    var email:String?
    var password:String?
    var addharId:String?
    var devices:[CardModel]?
    
    //MARK: - Initializer
    init(email:String, password:String, addhar:String, devices:[CardModel]? = nil) {
        self.email = email
        self.password = password
        self.addharId = addhar
        self.devices = devices
    }
    
    //MARK: - Class functions
    class func logout() {
        //logout logic here
    }
    
    //MARK: - Functions
    func loginWithEmail(email:String, password:String) {
        //server logic here with parameters
    }
}
