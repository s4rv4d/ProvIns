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
    var dName:String
    var macAddress:String
    var ipAddress:String
    var uniqueId:String
    
    //MARK: - Initializer
    init(dname:String = "", macaddress:String = "", ipaddress:String = "", uniqueid:String = ""){
        self.dName = dname
        self.macAddress = macaddress
        self.ipAddress = ipaddress
        self.uniqueId = uniqueid
    }
    
}
