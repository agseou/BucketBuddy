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
    
    // 내프로필조회
    static func fetchMyProfile() -> Single<profileResult> {
        return Single<profileResult>.create { single in
            do {
                let urlRequest = try ProfileRouter.fetchMyProfile.asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: ProfileModel.self) { response in
                        switch response.result {
                        case .success(let profile):
                            single(.success(.success(profile)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 419:
                                single(.success(.expiredToken))
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
