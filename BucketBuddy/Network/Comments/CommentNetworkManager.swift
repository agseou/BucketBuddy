//
//  CommentNetworkManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import Alamofire

struct CommentNetworkManager {
    
    // 댓글 작성
    static func writeComments(query: CommentQuery, id: String) -> Single<CommnentModel> {
        return Single<CommnentModel>.create { single in
            do {
                let urlRequest = try CommentsRouter.writeComments(query: query, id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: CommnentModel.self) { response in
                        switch response.result {
                        case .success(let comments):
                            single(.success(comments))
                        case .failure(let error):
                            if let statusCode = response.response?.statusCode, !handleCommonErrors(statusCode) {
                                handleLoginStatusError(statusCode)
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // 댓글 수정
    static func writeComments(query: CommentQuery, id: String, commentID: String) -> Single<CommnentModel> {
        return Single<CommnentModel>.create { single in
            do {
                let urlRequest = try CommentsRouter.editComments(query: query, id: id, commentID: commentID).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: CommnentModel.self) { response in
                        switch response.result {
                        case .success(let comments):
                            single(.success(comments))
                        case .failure(let error):
                            if let statusCode = response.response?.statusCode, !handleCommonErrors(statusCode) {
                                handleLoginStatusError(statusCode)
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    // 댓글 삭제
    static func writeComments(id: String, commentID: String) -> Single<CommnentModel> {
        return Single<CommnentModel>.create { single in
            do {
                let urlRequest = try CommentsRouter.deleteComments(id: id, commentID: commentID).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: CommnentModel.self) { response in
                        switch response.result {
                        case .success(let comments):
                            single(.success(comments))
                        case .failure(let error):
                            if let statusCode = response.response?.statusCode, !handleCommonErrors(statusCode) {
                                handleLoginStatusError(statusCode)
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    
}
