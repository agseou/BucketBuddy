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
        case nickname
    }
    
    @UserDefault(key: Key.isAccessed.rawValue, defaultValue: false)
    var isAccessed: Bool
    
    @UserDefault(key: Key.nickname.rawValue, defaultValue: "끼끼")
    var nickname: String
}
