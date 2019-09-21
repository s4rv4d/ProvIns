//
//  ServerCall.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerCall {
    
    //MARK: - Enum
    enum Service: String {
        case signup = "test1"
        case login = "test2"
        case addCard = "test3"
        case displayCards = "test4"
    }
    
    //MARK: - Variables
    private var uuid: String!
    
    //MARK: - Functions
    private func serverBaseURL() -> String? { return "test5" }
    
    func call(service:Service, bodyParams:[String:Any]) {
        
    }
    
    //MARK: - Class functions (if any)
    
}
