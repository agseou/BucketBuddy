//
//  TokenUDManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

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
