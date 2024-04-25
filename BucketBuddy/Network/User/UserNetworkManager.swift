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
    
    // Login
    static func createLogin(query: LoginQuery) -> Single<LoginResult> {
        return Single<LoginResult>.create { single in
            do {
                let urlRequest = try UsersRouter.login(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let login):
                            single(.success(LoginResult.success(login)))
                        case .failure( _):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.unauthorized))
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
    
    // Join
    static func createJoin(query: JoinQuery) -> Single<JoinResult> {
        return Single<JoinResult>.create { single in
            do {
                let urlRequest = try UsersRouter.join(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: JoinModel.self) { response in
                        switch response.result {
                        case .success(let join):
                            single(.success(JoinResult.success(join)))
                        case .failure( _):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 409:
                                single(.success(.conflict))
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
    
    // Refresh
    static func refreshAcessToken() -> Single<RefreshTokenResult> {
        return Single<RefreshTokenResult>.create { single in
            do {
                let urlRequest = try UsersRouter.refreshToken.asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: RefreshTokenModel.self) { response in
                        switch response.result {
                        case .success(let refresh):
                            single(.success(.success(refresh)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 418:
                                single(.success(.ReLogin))
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
    
    static func vaildationEmail(query: validationEmailQuery) -> Single<validationModel> {
        return Single<validationModel>.create { single in
            do {
                let urlRequest = try UsersRouter.validationEmail(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: validationModel.self) { response in
                        switch response.result {
                        case .success(let vaildation):
                            single(.success(vaildation))
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
