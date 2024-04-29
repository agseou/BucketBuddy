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
                switch result {
                case .success(let success):
                    followers.accept(success.followers)
                    followings.accept(success.following)
                case .unauthorized:
                    print("유효하지 않은 액세스 토큰")
                case .forbidden:
                    print("접근권한 없음")
                case .expiredToken:
                    print("에러 발생: 토큰 만료")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(followers: followers.asDriver(onErrorJustReturn: []),
                      followings: followings.asDriver(onErrorJustReturn: []))
    }
    
}
