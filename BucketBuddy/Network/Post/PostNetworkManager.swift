//
//  PostNetworkManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import Alamofire


struct PostNetworkManager {
    
    // 이미지업로드
    static func uploadImage(query: uploadIamgeQuery, id: String) -> Single<uploadIamgeModel> {
        return Single<uploadIamgeModel>.create { single in
            do {
                let urlRequest = try PostRouter.uploadImage(query: query, id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: uploadIamgeModel.self) { response in
                        switch response.result {
                        case .success(let images):
                            single(.success(images))
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
    
    // 포스트 작성
    static func writePost(query: WritePostQuery) -> Single<WritePostModel> {
        return Single<WritePostModel>.create { single in
            do {
                let urlRequest = try PostRouter.createPost(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: WritePostModel.self) { response in
                        switch response.result {
                        case .success(let post):
                            single(.success(post))
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
    
    // 항목별 전체 포스트 조회
    static func fetchPost(query: FetchPostQuery) -> Single<FetchPostModel> {
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchPost(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let post):
                            single(.success(post))
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
    
    
    // 포스트 수정
    static func editPost(query: WritePostQuery, id: String) -> Single<WritePostModel> {
        return Single<WritePostModel>.create { single in
            do {
                let urlRequest = try PostRouter.editPost(query: query, id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: WritePostModel.self) { response in
                        switch response.result {
                        case .success(let post):
                            single(.success(post))
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
    
    // 특정 포스트 조회
    static func fetchUserPost(id: String) -> Single<FetchPostModel> {
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchPostDetail(id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let post):
                            single(.success(post))
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
    
    
    // 이용자별 포스트 조회
    static func fetchUserPost(query: FetchPostQuery, userID: String) -> Single<FetchPostModel> {
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchUserPost(query: query, id: userID).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let post):
                            single(.success(post))
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
