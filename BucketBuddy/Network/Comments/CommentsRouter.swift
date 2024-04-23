//
//  CommentsRouter.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

enum CommentsRouter {
    case writeComments(query: CommentQuery,id: String)
    case editComments(query: CommentQuery, id: String, commentID: String)
    case deleteComments(id: String, commentID: String)
}

extension CommentsRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue + "v1/posts/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .writeComments:
                .post
        case .editComments:
                .put
        case .deleteComments:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .writeComments(let query, let id):
                return "\(id)/comments"
        case .editComments(let query, let id, let commentID):
            return "\(id)/comments/\(commentID)"
        case .deleteComments(let id, let commentID):
            return "\(id)/comments/\(commentID)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .writeComments, .editComments:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
             HTTPHeader.secretKey.rawValue: APIKey.secretKey.rawValue]
        case .deleteComments:
            [HTTPHeader.authorization.rawValue: TokenUDManager.shared.accessToken,
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
        case .writeComments(let query, let id):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .editComments(let query, let id, let commentID):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .deleteComments:
            return nil
        }
    }
    
    
    
    
}

