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
    let followers: [FollowModel]
    let following: [FollowModel]
    let posts: [String]
}
