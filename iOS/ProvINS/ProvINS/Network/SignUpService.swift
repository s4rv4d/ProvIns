//
//  SignUpService.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AWSCore

class SignUpService {
    
    func call(with request:SignUpRequest) -> AWSTask<SignUpResponse> {
        return ServerCall().call(service: .signup, method: .post, with: request.json, parameterEncoding: JSONEncoding.default).continueOnSuccessWith(block: { (task) -> Any? in
            do { return try SignUpResponse(task.result!) }
            catch {
                return AWSTask<AnyObject>(error: error)
            }
        }) as! AWSTask<SignUpResponse>
    }
}

class SignUpRequest {
    var email:String?
    
    init(email:String) {
        self.email = email
    }
    
    var json: [String:String] { return ["email":self.email as! String]}
}


class SignUpResponse {
    var _id: String?
    var email: String?
    var password: String?
    var devices: [CardModel]? = []
    var __v:Int?
    
    init(_ serverResponse: AnyObject) throws {
        let json = JSON(serverResponse)
        print(json)
        if json == JSON.null { throw ProvinsError.invalidServerResponse }
        
        if let data = json.dictionary {
            
            if let id = data["_id"]?.stringValue {
                self._id = id
            }
            
            if let email = data["email"]?.stringValue {
                self.email = email
            }
            
            if let password = data["password"]?.stringValue {
                self.password = password
            }
            
            if let _v = data["__v"]?.intValue {
                self.__v = _v
            }
            
            if let devices = data["devices"]?.arrayValue {
                print(devices)
                let cards = devices.map{
                    CardModel(devName: $0["devName"].stringValue, devType: $0["devType"].stringValue, macaddress: $0["mac"].stringValue, ipaddress: $0["ip"].stringValue, uniqueid: $0["uid"].stringValue, bltName: $0["blueName"].stringValue, rand: $0["rand"].stringValue)
                }
                
                self.devices = cards
            }        } else {
            throw ProvinsError.invalidServerResponse
        }
    }
}

