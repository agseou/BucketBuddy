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
        let nicknameRegex = "^(?=.*[a-zA-Z가-힣])[a-zA-Z가-힣0-9]{2,8}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES[c] %@", nicknameRegex)
        
        input.nickname
            .subscribe(with: self) { owner, nickname in
                if nicknamePredicate.evaluate(with: nickname) {
                    nicknameVaildation.accept(true)
                } else {
                    nicknameVaildation.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(nicknameVaildation: nicknameVaildation.asDriver())
    }
    
}
