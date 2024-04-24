//
//  SetupEmailViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class SetUpEmailViewModel: CommonViewModel {
    
    struct Input {
        let email: Observable<String>
    }
    
    struct Output {
        let emailVaildation: Driver<Bool> // 로그인 문자열 유효성 검증
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let emailVaildation = BehaviorRelay<Bool>(value: false)
        
        
        input.email
            .bind(with: self) { owner, nickname in
                emailVaildation.accept(true)
            }
            .disposed(by: disposeBag)
        
        return Output(emailVaildation: emailVaildation.asDriver())
    }
}

