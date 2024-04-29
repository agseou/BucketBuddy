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
    }
    
    @UserDefault(key: Key.isAccessed.rawValue, defaultValue: false)
    var isAccessed: Bool
    
    @UserDefault(key: Key.userID.rawValue, defaultValue: "")
    var userID: String
}
