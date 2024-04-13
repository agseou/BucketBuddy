//
//  Router.swift
//  BucketBuddy
//
//  Created by eunseou on 4/11/24.
//

import Foundation
import Alamofire

enum UsersRouter {
    case join(query: joinQuery)
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
        case .join(let query):
                .post
        case .validationEmail(let query):
                .post
        case .login(let query):
                .post
        case .refreshToken:
                .get
        case .withdraw:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .join(let query):
            "users/join"
        case .validationEmail(let query):
            "validatoin/email"
        case .login(let query):
            "users/login"
        case .refreshToken:
            "auth/refresh"
        case .withdraw:
            "users/withdraw"
        }
    }
    
    var header: [String : String] {
        [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
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
        case .join(let query):
            let encoder = JSONEncoder() //JsonType으로 전달!
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .validationEmail(let query):
            let encoder = JSONEncoder() //JsonType으로 전달!
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .login(let query):
            let encoder = JSONEncoder() //JsonType으로 전달!
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .refreshToken:
            return nil
        case .withdraw:
            return nil
        }
    }
}
