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
        let profileImage: Observable<String?>
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
            .flatMapLatest { query -> Observable<Void> in
                ProfileNetworkManager.editMyProfile(query: query)
                    .asObservable()
                    .map { profile -> Void in
                        DefaultUDManager.shared.nickname = profile.nick
                        if let imageURL = profile.profileImage {
                            DefaultUDManager.shared.profileURL = imageURL
                        }
                        return Void()
                    }
                    .catchAndReturn(Void())  // 에러
            }
            .subscribe(onNext: {
                successResult.accept(())  // 성공
            })
            .disposed(by: disposeBag)
        
        return Output(successResult: successResult.asDriver(onErrorJustReturn: ()))
    }
}
