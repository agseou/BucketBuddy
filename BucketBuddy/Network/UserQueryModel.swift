//
//  UserQueryModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation

struct joinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}

struct validationEmailQuery: Encodable {
    let email: String
}

struct LoginQuery: Encodable {
    let email: String
    let password: String
}
