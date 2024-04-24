//
//  JoinViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa

class JoinViewModel: CommonViewModel {
    
    // Relay로 이메일, 비밀번호, 닉네임을 저장
    var emailRelay = BehaviorRelay<String?>(value: nil)
    var passwordRelay = BehaviorRelay<String?>(value: nil)
    var nicknameRelay = BehaviorRelay<String?>(value: nil)
    
    struct Input {
        let email: Observable<String?>
        let password: Observable<String?>
        let nickname: Observable<String?>
        let joinTap: Observable<Void>
    }
    
    struct Output {
        let joinSuccess: Driver<Void>
        let errorMessage: Driver<String?>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let joinSuccess = PublishRelay<Void>()
        let errorMessage = PublishRelay<String?>()
        
        let joinObservable = Observable.combineLatest(input.email, input.password, input.nickname, resultSelector: {(email, password, nickname) in
            return JoinQuery(email: email ?? "", password: password ?? "", nick: nickname ?? "")
        })
        
        input.joinTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(joinObservable)
            .flatMapLatest { query in
                UserNetworkManager.createJoin(query: query)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    joinSuccess.accept(())
                case .badRequest:
                    print("요청")
                case .conflict:
                    errorMessage.accept("이미 가입한 유저입니다.")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(joinSuccess: joinSuccess.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: nil))
    }
}
