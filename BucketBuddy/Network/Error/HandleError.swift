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

// MARK: - User
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

enum RefreshTokenResult {
    case success(RefreshTokenModel)
    case unauthorized
    case forbidden
    case ReLogin
    case error(CommonError)
}

// MARK: - Post

enum UploadImageResult{
    case success(uploadImageModel)
    case badRequest
    case unauthorized
    case forbidden
    case expiredAccessToken
    case error(CommonError)
}

enum CreatePostResult{
    case success(WritePostModel)
    case unauthorized
    case forbidden
    case nonePost
    case expiredAccessToken
    case error(CommonError)
}

enum DeletePostResult{
    case success(Void)
    case unauthorized
    case forbidden
    case nonePost
    case expiredAccessToken
    case error(CommonError)
}

enum CompleteTogglePostResult{
    case success(WritePostModel)
    case forbidden
    case nonePost
    case expiredAccessToken
    case noPermission
    case error(CommonError)
}


// MARK: - Profile
enum UserProfileResult {
    case success(FetchPostModel)
    case badRequest
    case unauthorized
    case forbidden
    case expiredAccessToken
    case error(CommonError)
}
