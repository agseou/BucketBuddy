//
//  LikeRouter.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

enum LikeRouter {
    case toggleLike(query: LikeModel,id: String)
    case fetchLikePost(query: LikeModel)
}

extension LikeRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/posts/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .toggleLike:
                .post
        case .fetchLikePost:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .toggleLike(let query, let id):
            return "\(id)/like"
        case .fetchLikePost(let query):
            return "likes/me"
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
        switch self {
        case .toggleLike(let query, let id):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .fetchLikePost:
            return nil
        }
    }
    
    
}
