//
//  ProfileModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation

struct ProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let followers: [UserModel]
    let following: [UserModel]
    let posts: [String]
}

struct UserModel: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

