//
//  DefaultUDManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation

class DefaultUDManager {
    
    static let shared = DefaultUDManager()
    
    enum Key: String {
        case isAccessed
        case userID
        case nickname
        case email
        case password
    }
    
    @UserDefault(key: Key.isAccessed.rawValue, defaultValue: false)
    var isAccessed: Bool
    
    @UserDefault(key: Key.userID.rawValue, defaultValue: "")
    var userID: String
    
    @UserDefault(key: Key.nickname.rawValue, defaultValue: "끼끼")
    var nickname: String
    
    @UserDefault(key: Key.email.rawValue, defaultValue: "")
    var email: String
    
    @UserDefault(key: Key.password.rawValue, defaultValue: "")
    var password: String
}
