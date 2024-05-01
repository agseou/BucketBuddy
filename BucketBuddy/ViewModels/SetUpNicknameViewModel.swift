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
        let nicknameVaildation: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        
        let nicknameVaildation = BehaviorRelay<Bool>(value: false)
        
        input.nickname
            .subscribe(with: self) { owner, nickname in
                if nickname.count > 1 && nickname.count < 11 {
                    nicknameVaildation.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(nicknameVaildation: nicknameVaildation.asDriver())
    }
    
}
