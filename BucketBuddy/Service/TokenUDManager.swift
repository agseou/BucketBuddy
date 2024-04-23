//
//  TokenUDManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation

class TokenUDManager {
    
    static let shared = TokenUDManager()
    
    enum Key: String {
        case accessToken
        case refreshToken
    }
    
    @UserDefault(key: Key.accessToken.rawValue, defaultValue: "")
    var accessToken: String
    
    @UserDefault(key: Key.refreshToken.rawValue, defaultValue: "")
    var refreshToken: String
}
