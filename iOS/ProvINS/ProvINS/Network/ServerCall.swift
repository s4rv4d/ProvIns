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
import AWSCore

class ServerCall {
    
    //MARK: - Enum
    enum Service: String {
        case signup = "newSignup"
        case login = "login"
        case addCard = "add"
        case displayCards = "display"
        case delete = "delete"
    }
    
    //MARK: - Variables
    private var uuid: String!
    
    //MARK: - Functions
    private func serverBaseURL() -> String? { return "https://provins.herokuapp.com/" }
    
    func call(service:Service, method: HTTPMethod? = .post, with bodyParam: [String: Any]? = nil, parameterEncoding: ParameterEncoding) -> AWSTask<AnyObject> {
        let taskCompletionSource = AWSTaskCompletionSource<AnyObject>()
        let serviceURL = serverBaseURL()! + service.rawValue
        
        DispatchQueue.global(qos: .background).async {  // If done on the main queue, the Alamofire call causes UI to freeze.
            DispatchQueue.main.async {
                //loading animation
            }

            Alamofire.request(serviceURL, method: method!, parameters: bodyParam!, encoding: parameterEncoding).responseJSON(options: JSONSerialization.ReadingOptions(), completionHandler: { (response) in
                
                switch response.result {
                case .success(let responseJSON):
                    let response = JSON(responseJSON)
                    print("could this be the data: ",response)
                    
                    if response.null == nil {
                        taskCompletionSource.set(result: responseJSON as AnyObject)
                    } else {
                        taskCompletionSource.set(error: ProvinsError.generic.nsError)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    taskCompletionSource.set(error: error)
                }
            })
            
        }
        
        return taskCompletionSource.task
    }
    
    //MARK: - Class functions (if any)
    
}
