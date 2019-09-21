//
//  ProvinsError.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation

enum ProvinsError: Error {
    
    case invalidServerResponse
    case generic
    case unAuthorizedAccess
    case incorrectOTP
    case userDoesNotExistWithMobileOrEmail
    case chatIDNotFound
    case userIDMissingParameter
    case chatHistoryNotFound
    case fetchTokenError
    case resultTimeOut
    case invalidToken
    
    var nsError: NSError {
        return NSError(domain: "Rivi", code: code, userInfo: nil)
    }
    
    fileprivate var code: Int {
        switch self {
        case .invalidServerResponse:               return 9050
        case .generic:                             return 9000
        case .unAuthorizedAccess:                  return 222
        case .incorrectOTP:                        return 216
        case .userDoesNotExistWithMobileOrEmail:   return 209
        case .chatIDNotFound:                      return 223
        case .userIDMissingParameter:              return 210
        case .chatHistoryNotFound:                 return 224
        case .fetchTokenError:                     return 9051
        case .resultTimeOut:                       return 226
        case .invalidToken:                        return 221
        }
    }
    
}

class InternetConnection {
    static func isNotAvailable(error: Error) -> Bool {
        return (error as NSError).code == -1009 || (error as NSError).code == -1001
    }
}
