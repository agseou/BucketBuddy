//
//  TokenUDManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation

class TokenUDManager {
    
    static let shared = TokenUDManager()
    
    enum UDKey: String {
        case accessToken
        case refreshToken
    }
    
    let ud = UserDefaults.standard
    
    var accessToken: String {
        get { ud.string(forKey: UDKey.accessToken.rawValue) ?? "" }
        set { ud.setValue(newValue, forKey: UDKey.accessToken.rawValue) }
    }
    
    var refreshToken: String {
        get { ud.string(forKey: UDKey.accessToken.rawValue) ?? "" }
        set { ud.setValue(newValue, forKey: UDKey.accessToken.rawValue) }
    }
    
}
