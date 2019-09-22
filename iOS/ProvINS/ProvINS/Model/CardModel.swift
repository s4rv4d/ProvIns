//
//  CardModel.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation


struct CardModel{
    
    //MARK: - Variables
    var devName:String
    var devType:String
    var macAddress:String
    var ipAddress:String
    var uniqueId:String
    var bltName:String
    var rand:String
    
    //MARK: - Initializer
    init(devName:String = "", devType:String = "",macaddress:String = "", ipaddress:String = "", uniqueid:String = "", bltName:String = "",rand:String = ""){
        self.devName = devName
        self.devType = devType
        self.macAddress = macaddress
        self.ipAddress = ipaddress
        self.uniqueId = uniqueid
        self.bltName = bltName
        self.rand = rand
    }
    
}
