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
    static func fetchMyProfile() -> Single<ProfileModel> {
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.fetchMyProfile.asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: ProfileModel.self) { response in
                        switch response.result {
                        case .success(let profile):
                            single(.success(profile))
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
}
