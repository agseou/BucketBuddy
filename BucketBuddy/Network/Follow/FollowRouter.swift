//
//  FollowRouter.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

enum FollowRouter {
    case follow(id: String)
    case unFollow(id: String)
}

extension FollowRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/follow/"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow(let id):
                .post
        case .unFollow(let id):
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .follow(let id):
            return "\(id)"
        case .unFollow(let id):
            return "\(id)"
        }
    }
    
    var header: [String : String] {
        [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
         HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    
}
