//
//  SetupPasswordViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class SetupPasswordViewModel: CommonViewModel {
    
    struct Input {
        let password: Observable<String>
        let checkPassword: Observable<String>
    }
    
    struct Output {
        let passwordVaildation: Driver<Bool>
        let checkPasswordVaildation: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let passwordVaildation = BehaviorRelay<Bool>(value: false)
        let checkPasswordVaildation = BehaviorRelay<Bool>(value: false)
        let passwordRegex = "^(?=.*[a-zA-Z])(?=.*[A-Z])(?=.*\\W).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES[c] %@", passwordRegex)
        
        Observable.combineLatest(input.password, input.checkPassword)
            .bind(with: self) { owner, password in
                if password.0 == password.1 && !password.0.isEmpty && !password.1.isEmpty {
                    checkPasswordVaildation.accept(true)
                } else {
                    checkPasswordVaildation.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.password
            .bind(with: self) { owner, password in
                if passwordPredicate.evaluate(with: password) {
                    passwordVaildation.accept(true)
                } else {
                    passwordVaildation.accept(false)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(passwordVaildation: passwordVaildation.asDriver(), 
                      checkPasswordVaildation: checkPasswordVaildation.asDriver())
    }
}
