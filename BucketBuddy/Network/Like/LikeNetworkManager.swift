//
//  LikeNetworkManeger.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import Alamofire


struct LikeNetworkManager {
    
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
                                single(.failure(error))
                            
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // 내가 좋아요한 포스트 조회
    
}
