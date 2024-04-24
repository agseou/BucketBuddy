//
//  HandleError.swift
//  BucketBuddy
//
//  Created by eunseou on 4/18/24.
//

import Foundation
import Alamofire

enum CommonError: Int, Error {
    case invaildHeader = 420
    case tooManyRequests = 429
    case invalidURL = 444
    case serverError = 500
    case unknown = 999
}

enum LoginResult {
    case success(LoginModel)
    case badRequest
    case unauthorized
    case error(CommonError)
}

enum JoinResult {
    case success(JoinModel)
    case badRequest
    case conflict
    case error(CommonError)
}

enum profileResult {
    case success(ProfileModel)
    case unauthorized
    case forbidden
    case expiredToken
    case error(CommonError)
}
