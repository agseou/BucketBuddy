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
    }
    
    @UserDefault(key: Key.isAccessed.rawValue, defaultValue: false)
    var isAccessed: Bool
    
    @UserDefault(key: Key.userID.rawValue, defaultValue: "")
    var userID: String
    
    @UserDefault(key: Key.isAccessed.rawValue, defaultValue: "끼끼")
    var nickname: String
    
    @UserDefault(key: Key.isAccessed.rawValue, defaultValue: "none")
    var email: String
}
