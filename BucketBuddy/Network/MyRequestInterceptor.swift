//
//  AuthenticationInterceptor.swift
//  BucketBuddy
//
//  Created by eunseou on 4/25/24.
//

import UIKit
import Alamofire
import RxSwift


final class MyRequestInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        let accessToken = TokenUDManager.shared.accessToken
        if !accessToken.isEmpty {
            adaptedRequest.setValue(accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }
        completion(.success(adaptedRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
            UserNetworkManager.refreshAcessToken()
                .subscribe(onSuccess: { result in
                    TokenUDManager.shared.accessToken = result.accessToken
                    completion(.retry)
                }, onFailure: { error in
                    handleLogout()
                    completion(.doNotRetryWithError(error))
                })
                .disposed(by: disposeBag)
      
    }
}

private func handleLogout() {
    // 토큰 삭제
    TokenUDManager.shared.accessToken = ""
    TokenUDManager.shared.refreshToken = ""
    
    // SceneDelegate에서 로그인 화면으로 전환
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let sceneDelegate = scene.delegate as? SceneDelegate {
        sceneDelegate.showLoginScreen()
    }
}

