//
//  Router.swift
//  BucketBuddy
//
//  Created by eunseou on 4/11/24.
//

import Foundation
import Alamofire

enum UsersRouter {
    case join(query: JoinQuery)
    case validationEmail(query: validationEmailQuery)
    case login(query: LoginQuery)
    case refreshToken
    case withdraw
}

extension UsersRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .join:
                .post
        case .validationEmail:
                .post
        case .login:
                .post
        case .refreshToken:
                .get
        case .withdraw:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .join:
            "users/join"
        case .validationEmail:
            "validatoin/email"
        case .login:
            "users/login"
        case .refreshToken:
            "auth/refresh"
        case .withdraw:
            "users/withdraw"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .withdraw :
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
                 HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        default: [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
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
        case .join(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .validationEmail(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .login(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .refreshToken:
            return nil
        case .withdraw:
            return nil
        }
    }
}
