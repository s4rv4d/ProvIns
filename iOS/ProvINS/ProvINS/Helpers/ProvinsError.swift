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
    case userDoesNotExistWithMobileOrEmail
    case userIDMissingParameter
    case chatHistoryNotFound
    case fetchTokenError
    case resultTimeOut
    case incorrectDetails
    case internalError
    
    var nsError: NSError {
        return NSError(domain: "Rivi", code: code, userInfo: nil)
    }
    
    fileprivate var code: Int {
        switch self {
        case .invalidServerResponse:               return 9050
        case .generic:                             return 9000
        case .unAuthorizedAccess:                  return 222
        case .userDoesNotExistWithMobileOrEmail:   return 209
        case .userIDMissingParameter:              return 210
        case .chatHistoryNotFound:                 return 224
        case .fetchTokenError:                     return 9051
        case .resultTimeOut:                       return 226
        case .incorrectDetails:                    return 401
        case .internalError:                        return 500
        }
    }
    
}

class InternetConnection {
    static func isNotAvailable(error: Error) -> Bool {
        return (error as NSError).code == -1009 || (error as NSError).code == -1001
    }
}
