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
        let nickname: Observable<String>
        let profileImage: Observable<String>
        let submitBtnTap: Observable<Void>
    }
    
    struct Output{
        let successResult: Driver<Void>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let successResult = PublishRelay<Void>()
        
        let editProfileQuery = Observable.combineLatest(input.nickname, input.profileImage)
            .map { (nickname, profileImage) in
                return EditProfileQuery(nick: nickname, profileImage: profileImage)
            }
        
        input.submitBtnTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(editProfileQuery)
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
