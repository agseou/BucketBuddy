//
//  EditMyProfileViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class EditMyProfileViewModel: CommonViewModel {
    
    struct Input {
        let editQuery: Observable<EditProfileQuery>
    }
    
    struct Output{
        let successResult: Driver<Void>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let successResult = PublishRelay<Void>()
        
        input.editQuery
            .flatMapLatest{ query in
                ProfileNetworkManager.editMyProfile(query: query)
            }
            .subscribe(with: self) { owner, profile in
                DefaultUDManager.shared.nickname = profile.nick
            }
            .disposed(by: disposeBag)
        
        return Output(successResult: successResult.asDriver(onErrorJustReturn: ()))
    }
}
