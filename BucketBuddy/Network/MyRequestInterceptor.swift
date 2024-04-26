//
//  AuthenticationInterceptor.swift
//  BucketBuddy
//
//  Created by eunseou on 4/25/24.
//

import Foundation
import Alamofire
import RxSwift

final class MyRequestInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()  
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let accessToken = TokenUDManager.shared.accessToken
                
                // accessToken이 비어있는지 확인
                guard !accessToken.isEmpty else {
                    completion(.success(urlRequest))
                    return
                }

        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 418 else {
            completion(.doNotRetryWithError(error))
            return
        }

        // 418 에러 시 refreshAccessToken 함수를 호출
        UserNetworkManager.refreshAcessToken().subscribe { event in
            switch event {
            case .success(let result):
                switch result {
                case .success:
                    completion(.retry)
                case .unauthorized, .forbidden, .ReLogin, .error:
                    completion(.doNotRetry)
                }
            case .failure:
                completion(.doNotRetry)
            }
        }.disposed(by: disposeBag)
    }
   
}
