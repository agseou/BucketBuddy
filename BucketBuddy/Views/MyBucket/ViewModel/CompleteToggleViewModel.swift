//
//  CompleteToggleViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class CompleteToggleViewModel: CommonViewModel {
    
    struct Input {
        var trigger: Observable<(String, String)>
    }
    
    struct Output {
        var successSignal: Driver<Void>
        var errorMessage: Driver<String>
    }
    
    var disposeBag = DisposeBag()
   
    func transform(input: Input) -> Output {
        
        let successSignal = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        
        input.trigger
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest{ (productID, postID) in
                
                var query: String
                if productID == "bucket" { query = "completeBucket" }
                else { query = "bucket" }
                
                return PostNetworkManager.completeTogglePost(query: CompleteToggleQuery(product_id: query), id: postID)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    successSignal.accept(())
                case .forbidden:
                    print("입력값 확인")
                case .nonePost:
                    errorMessage.accept("존재하지 않는 포스트입니다.")
                case .expiredAccessToken:
                    print("엑세스 토큰 만료 -> refresh")
                case .noPermission:
                    errorMessage.accept("접근 권한이 없습니다.")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(successSignal: successSignal.asDriver(onErrorJustReturn: ()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    
}
