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
        let loginSuccess: Driver<Void>
        let errorMessage: Driver<String?>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let loginVaildation = BehaviorRelay<Bool>(value: false)
        let loginSuccess = PublishRelay<Void>()
        let errorMessage = PublishRelay<String?>()
        
        let loginObservable = Observable.combineLatest(input.email, input.password)
            .map { (email, password) in
                return LoginQuery(email: email, password: password)
            }
        
        loginObservable
            .bind(with: self) { owner, login in
                if login.email.contains("@") && login.password.count > 4 {
                    loginVaildation.accept(true)
                } else {
                    loginVaildation.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.loginTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) 
            .withLatestFrom(loginObservable)
            .flatMapLatest { query in
                UserNetworkManager.createLogin(query: query)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let loginModel):
                    TokenUDManager.shared.accessToken = loginModel.accessToken
                    TokenUDManager.shared.refreshToken = loginModel.refreshToken
                    DefaultUDManager.shared.userID = loginModel.user_id
                    loginSuccess.accept(())
                case .badRequest:
                    errorMessage.accept("") 
                case .unauthorized:
                    errorMessage.accept("계정을 확인해주세요!")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(loginVaildation: loginVaildation.asDriver(),
                      loginSuccess: loginSuccess.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: nil))
    }
}

