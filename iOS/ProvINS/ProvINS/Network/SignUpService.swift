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
    var password:String?
    var aadhaar:String?
    
    init(email:String, password:String, aadhaar:String) {
        self.email = email
        self.password = password
        self.aadhaar = aadhaar
    }
    
    var json: [String:Any] { return ["email":self.email as Any,"password":self.password as Any,"aadhaar":self.aadhaar as Any]}
}






class SignUpResponse {
    var _id: String?
    var email: String?
    var password: String?
    var aadhaar: String?
    var devices: [CardModel]? = []
    var __v:Int?
    var UserResponse: UserResponse?
    
    
    
    init(_ serverResponse: AnyObject) throws {
        let json = JSON(serverResponse)
        print(json)
        if json == JSON.null { throw ProvinsError.invalidServerResponse }
//        if let data = json["data"].dictionary {
//            if let userID = data["user_id"]?.int {
//                self.userID = "\(userID)"
//            }
//            if let firstName = data["firstname"]?.string {
//                self.firstName = firstName
//            }
//            if let authToken = data["access_token"]?.string {
//                self.authToken = authToken
//            }
//            if let signUpType = data["signup_type"]?.string, signUpType == "facebook" || signUpType == "google" {
//                let user = UserResponse()
////                if let country_code = data["country_code"]?.string {
////                    user.countryCode = country_code
////                }
////                if let google_id = data["google_id"]?.string {
////                    user.googleUserID = google_id
////                }
////                if let signup_type = data["signup_type"]?.string {
////                    user.signupType = signup_type
////                }
////                if let email_verified = data["email_verified"]?.int {
////                    user.isEmailIDVerified = email_verified == 0 ? false : true
////                }
////                if let first_name = data["first_name"]?.string {
////                    user.firstName = first_name
////                }
////                if let last_update_date = data["last_update_date"]?.string {
////                    user.lastUpdateDate = Date()
////                }
////                if let username = data["username"]?.string {
////                    user.userName = username
////                }
////                if let facebook_id = data["facebook_id"]?.string {
////                    user.facebookUserID = facebook_id
////                }
////                if let gender = data["gender"]?.string {
////                    user.gender = gender
////                }
////                if let token = data["token"]?.string {
////                    user.socketToken = token
////                }
////                if let image_link = data["image_link"]?.string {
////                    user.imageLinkString = image_link
////                }
////                if let mobile_number = data["mobile_number"]?.string {
////                    user.mobileNumber = mobile_number
////                }
////                if let registered_date = data["registered_date"]?.string {
////                    user.registrationDate = Date()
////                }
////                if let last_name = data["last_name"]?.string {
////                    user.lastName = last_name
////                }
////                if let is_active = data["is_active"]?.int {
////                    user.isActive = is_active == 0 ? false : true
////                }
////                if let mobile_verified = data["mobile_verified"]?.int {
////                    user.isMobileNumberVerified = mobile_verified == 0 ? false : true
////                }
////                if let official_email = data["official_email"]?.string {
////                    user.officialEmailID = official_email
////                }
////                if let social_email = data["social_email"]?.string {
////                    user.socialEmailID = social_email
////                }
////                if let userid = data["userid"]?.int {
////                    user.userID = "\(userid)"
////                }
////                if let dob = data["dob"]?.string {
////                    user.dob = dob
////                }
////                if let city = data["city"]?.string {
////                    user.city = city
////                }
//                self.socialUserResponse = user
//            }
//        } else {
//            throw ProvinsError.invalidServerResponse
//        }
    }
}

