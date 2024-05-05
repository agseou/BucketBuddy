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

extension UserModel {
    static var defaultUserModel: UserModel {
        return UserModel(
            user_id: "",
            nick: "",
            profileImage: nil
        )
    }
}

struct EditProfileQuery: Encodable {
    let nick: String
    let profileImage: String?
}

extension ProfileModel {
    static var defaultProfile: ProfileModel {
        return ProfileModel(user_id: "", email: "", nick: "", profileImage: nil, followers: [], following: [], posts: [])
    }
}
