//
//  HashtagRouter.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

enum HashtagRouter {
    case searchHashtags
}

extension HashtagRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/posts/"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var path: String {
        "hashtags"
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
