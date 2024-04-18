//
//  SetUpNicknameViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

class SetUpNicknameViewModel: CommonViewModel {
    
    struct Input {
        let nickname: Observable<String>
    }
    
    struct Output {
        let nicknameVaildation: Driver<Bool> // 로그인 문자열 유효성 검증
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let loginVaildation = BehaviorRelay<Bool>(value: false)
        
        input.nickname
            .bind(with: self) { owner, nickname in
                loginVaildation.accept(true)
            }
            .disposed(by: disposeBag)
        
        return Output(nicknameVaildation: loginVaildation.asDriver())
    }
}
