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
    static func uploadImage(query: uploadIamgeQuery) -> Single<UploadImageResult> {
        return Single<UploadImageResult>.create { single in
            do {
                let urlRequest = try PostRouter.uploadImage(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: uploadIamgeModel.self) { response in
                        switch response.result {
                        case .success(let images):
                            single(.success(.success(images)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 419:
                                single(.success(.expiredAccessToken))
                            default:
                                single(.success(.error(.unknown)))
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
    static func writePost(query: WritePostQuery) -> Single<CreatePostResult> {
        return Single<CreatePostResult>.create { single in
            do {
                let urlRequest = try PostRouter.createPost(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: WritePostModel.self) { response in
                        print(response)
                        switch response.result {
                        case .success(let post):
                            single(.success(.success(post)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 410:
                                single(.success(.nonePost))
                            case 419:
                                single(.success(.expiredAccessToken))
                            default:
                                single(.success(.error(.unknown)))
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
                                single(.failure(error))
                            
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
                                single(.failure(error))
                            
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
                                single(.failure(error))
                            
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    // 포스트 삭제
    static func deletePost(postID: String) -> Single<DeletePostResult> {
        return Single<DeletePostResult>.create { single in
            do {
                let urlRequest = try PostRouter.deletePost(id: postID).asURLRequest()
                AF.request(urlRequest).response { response in
                        switch response.result {
                        case .success(_):
                            single(.success(.success(())))
                        case .failure(let error):
                            switch response.response?.statusCode {
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 410:
                                single(.success(.nonePost))
                            case 419:
                                single(.success(.expiredAccessToken))
                            default:
                                single(.success(.error(.unknown)))
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
    static func fetchUserPost(query: FetchPostQuery, userID: String) -> Single<UserProfileResult> {
        return Single<UserProfileResult>.create { single in
            do {
                let urlRequest = try PostRouter.fetchUserPost(query: query, id: userID).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let post):
                            single(.success(.success(post)))
                        case .failure(let error):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 419:
                                single(.success(.expiredAccessToken))
                            default:
                                single(.success(.error(.unknown)))
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
