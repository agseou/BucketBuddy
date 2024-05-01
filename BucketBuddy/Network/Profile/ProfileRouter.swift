//
//  ProfileRouter.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case fetchMyProfile
    case editMyProfile(query: EditProfileQuery)
    case fetchUserProfile(id: String)
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/users/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile, .fetchUserProfile:
                .get
        case .editMyProfile:
                .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile, .editMyProfile:
            return "me/profile"
        case .fetchUserProfile(let id):
            return "\(id)/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyProfile, .fetchUserProfile:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
             HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        case .editMyProfile:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
            HTTPHeader.contentType.rawValue: HTTPHeader.multifart.rawValue,
             HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        switch self {
        case .fetchMyProfile:
            nil
        case .editMyProfile:
            nil
        case .fetchUserProfile(let id):
            nil
        }
    }
    
    
}
