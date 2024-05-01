//
//  FetchMyProfileViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class FetchMyProfileViewModel: CommonViewModel {
    
    struct Input {
        let fetchTrigger: Observable<Void>
    }
    
    struct Output{
        let profileResult: Driver<ProfileModel>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let profileResult = PublishRelay<ProfileModel>()
        
        input.fetchTrigger
            .flatMapLatest{
                ProfileNetworkManager.fetchMyProfile()
            }
            .subscribe(with: self) { owner, profile in
                profileResult.accept(profile)
            }
            .disposed(by: disposeBag)
        
        return Output(profileResult: profileResult.asDriver(onErrorJustReturn: ProfileModel.defaultProfile))
    }
    
}
