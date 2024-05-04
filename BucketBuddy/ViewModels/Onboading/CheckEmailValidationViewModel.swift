//
//  CheckEmailValidationViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class CheckEmailValidationViewModel: CommonViewModel {
    
    struct Input {
        let email: Observable<String>
        let tapEmailValidatoinBtn: Observable<Void>
    }
    
    struct Output {
        let validationResult: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let validationResult = PublishRelay<String>()
        
        input.tapEmailValidatoinBtn
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .flatMapLatest { email in
                guard !email.isEmpty else {
                    return Observable.just(validationModel(message: "이메일을 입력하세요"))
                }
                return UserNetworkManager.vaildationEmail(query: validationEmailQuery(email: email)).asObservable()
            }
            .subscribe(with: self) { owner, result in
                validationResult.accept(result.message)
            }
            .disposed(by: disposeBag)
        
        
        return Output(validationResult: validationResult.asDriver(onErrorJustReturn: "이메일을 입력하세요"))
    }
}

