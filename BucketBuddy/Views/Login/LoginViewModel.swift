//
//  LoginViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: CommonViewModel {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let loginTap: Observable<Void>
    }
    
    struct Output {
        let loginVaildation: Driver<Bool> // 로그인 문자열 유효성 검증
        let loginResult: Driver<Result<LoginModel, Error>> // 로그인 결과
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let loginVaildation = BehaviorRelay<Bool>(value: false)
        
        let loginObservable = Observable.combineLatest(input.email, input.password)
            .map { (email, password) in
                return LoginQuery(email: email, password: password)
            }
        
        loginObservable
            .bind(with: self) { owner, login in
                if login.email.contains("@") && login.password.count > 5 {
                    loginVaildation.accept(true)
                } else {
                    loginVaildation.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        let loginResult = input.loginTap
            .withLatestFrom(loginObservable)
            .flatMapLatest { query in
                NetworkManager.createLogin(query: query)
                    .map { result in
                        TokenUDManager.shared.accessToken = result.accessToken
                        TokenUDManager.shared.refreshToken = result.refreshToken
                        return Result.success(result)
                    }
                    .catch { error in
                        Single.just(Result.failure(error))
                    }
            }.asDriver(onErrorDriveWith: Driver.empty()) // 아무것도 방출X
        
        return Output(loginVaildation: loginVaildation.asDriver(), loginResult: loginResult)
    }
}
