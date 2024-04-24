//
//  FetchMyProfile.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class FetchMyProfileViewModel: CommonViewModel {
    
    struct Input {
        let fetchTrigger: Observable<Void>
    }
    
    struct Output{
        let nickname: Driver<String>
        let profileImage: Driver<String>
        let followerCnt: Driver<Int>
        let followingCnt: Driver<Int>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        var nickname = PublishRelay<String>()
        var profileImage = PublishRelay<String>()
        var followerCnt = PublishRelay<Int>()
        var followingCnt = PublishRelay<Int>()
            
        input.fetchTrigger
            .flatMapLatest { _ in
                ProfileNetworkManager.fetchMyProfile()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    nickname.accept(success.nick)
                    profileImage.accept(success.profileImage ?? "monkey")
                    followerCnt.accept(success.followers.count)
                    followingCnt.accept(success.following.count)
                case .unauthorized:
                    print("유효하지 않은 액세스 토큰")
                case .forbidden:
                    print("접근권한 없음")
                case .expiredToken:
                    print("에러 발생: 토큰 만료")
                case .error(let error):
                    print("!!!에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
            
        
       return Output(nickname: nickname.asDriver(onErrorJustReturn: ""),
               profileImage: profileImage.asDriver(onErrorJustReturn: ""),
               followerCnt: followerCnt.asDriver(onErrorJustReturn: 0),
               followingCnt: followingCnt.asDriver(onErrorJustReturn: 0))
    }
    
}
