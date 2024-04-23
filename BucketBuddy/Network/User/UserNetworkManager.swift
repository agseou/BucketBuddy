//
//  NetworkManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation
import RxSwift
import Alamofire

struct UserNetworkManager {
    
    // Login Model
    static func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { single in
            do {
                let urlRequest = try UsersRouter.login(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let login):
                            single(.success(login))
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
    
    static func createJoin(query: JoinQuery) -> Single<JoinModel> {
        return Single<JoinModel>.create { single in
            do {
                let urlRequest = try UsersRouter.join(query: query).asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: JoinModel.self) { response in
                        switch response.result {
                        case .success(let join):
                            single(.success(join))
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
