//
//  UserQueryModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation

// MARK: - Join
struct JoinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}

struct JoinModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

// MARK: - ValidationEmail
struct validationEmailQuery: Encodable {
    let email: String
}

struct validationModel: Decodable {
    let message: String
}

// MARK: - RefreshToken
struct RefreshTokenModel: Decodable {
    let accessToken: String
}

// MARK: - Login
struct LoginQuery: Encodable {
    let email: String
    let password: String
}

struct LoginModel: Decodable {
    let accessToken: String
    let refreshToken: String
}
