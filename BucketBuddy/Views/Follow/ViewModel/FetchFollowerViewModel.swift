//
//  FetchFollowerViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

class FetchFollowerViewModel: CommonViewModel {
    
    struct Input {
        let fetchTrigger: Observable<Void>
    }
    
    struct Output{
        let followers: Driver<[UserModel]>
        let followings: Driver<[UserModel]>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let followers = PublishRelay<[UserModel]>()
        let followings = PublishRelay<[UserModel]>()
            
        input.fetchTrigger
            .flatMapLatest { _ in
                return ProfileNetworkManager.fetchMyProfile()
            }
            .subscribe(with: self) { owner, result in
               
            }
            .disposed(by: disposeBag)
            
        
        return Output(followers: followers.asDriver(onErrorJustReturn: []),
                      followings: followings.asDriver(onErrorJustReturn: []))
    }
    
}
