//
//  ProfileNetworkManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import Alamofire


struct ProfileNetworkManager {
    
    // 좋아요 쓰기
    static func writeComments(query: LikeModel, id: String) -> Single<LikeModel> {
        return Single<LikeModel>.create { single in
            do {
                let urlRequest = try LikeRouter.toggleLike(query: query, id: id).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: LikeModel.self) { response in
                        switch response.result {
                        case .success(let likes):
                            single(.success(likes))
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
