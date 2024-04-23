//
//  FollowNetworkManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import Alamofire


struct FollowNetworkManager {
    
    // 팔로우
    static func follow(id: String) -> Single<FollowModel> {
        return Single<FollowModel>.create { single in
            do {
                let urlRequest = try FollowRouter.follow(id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: FollowModel.self) { response in
                        switch response.result {
                        case .success(let follow):
                            single(.success(follow))
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
    
    // 언팔로우
    static func unFollow(id: String) -> Single<FollowModel> {
        return Single<FollowModel>.create { single in
            do {
                let urlRequest = try FollowRouter.unFollow(id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: FollowModel.self) { response in
                        switch response.result {
                        case .success(let follow):
                            single(.success(follow))
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
