//
//  PostRouter.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case uploadImage(query: uploadIamgeQuery)
    case createPost(query: WritePostQuery)
    case fetchPost(query: FetchPostQuery)
    case fetchPostDetail(id: String)
    case editPost(query: WritePostQuery, id: String)
    case deletePost(id: String)
    case fetchUserPost(query: FetchPostQuery, id: String)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImage, .createPost:
                .post
        case .fetchPost, .fetchPostDetail, .fetchUserPost:
                .get
        case .editPost:
                .put
        case .deletePost:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .uploadImage:
            return "posts/files"
        case .createPost:
            return "posts"
        case .fetchPost:
            return "posts"
        case .fetchPostDetail(let id):
            return "posts/\(id)"
        case .editPost(_, let id):
            return "posts/\(id)"
        case .deletePost(let id):
            return "posts/\(id)"
        case .fetchUserPost(_, let id):
            return "posts/users/\(id)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .uploadImage:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
             HTTPHeader.contentType.rawValue: HTTPHeader.multifart.rawValue,
             HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        case .createPost, .editPost:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
             HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
             HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        case .fetchPost, .fetchPostDetail, .fetchUserPost, .deletePost:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
             HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        }
        
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPost(let query):
            [URLQueryItem(name: "next", value: query.next),
             URLQueryItem(name: "limit", value: query.limit),
             URLQueryItem(name: "product_id", value: query.product_id)]
        case .fetchUserPost(let query, _):
            [URLQueryItem(name: "next", value: query.next),
             URLQueryItem(name: "limit", value: query.limit),
             URLQueryItem(name: "product_id", value: query.product_id)]
        default:
            nil
        }
    }
    
    var body: Data? {
        switch self {
        case .uploadImage(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .createPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .fetchPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .fetchPostDetail:
            return nil
        case .editPost(let query, _):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .deletePost:
            return nil
        case .fetchUserPost(let query, _):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
    
    
}
