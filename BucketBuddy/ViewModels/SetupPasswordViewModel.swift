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
        
        Observable.combineLatest(input.password, input.checkPassword)
            .bind(with: self) { owner, password in
                if password.0 == password.1 {
                    checkPasswordVaildation.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.password
            .bind(with: self) { owner, password in
                if password.count > 7 {
                    passwordVaildation.accept(true)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(passwordVaildation: passwordVaildation.asDriver(), 
                      checkPasswordVaildation: checkPasswordVaildation.asDriver())
    }
}
