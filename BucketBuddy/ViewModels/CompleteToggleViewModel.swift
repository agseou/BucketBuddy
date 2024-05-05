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
    }
    
    var disposeBag = DisposeBag()
   
    func transform(input: Input) -> Output {
        
        let successSignal = PublishRelay<Void>()
        
        input.trigger
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest{ (productID, postID) in
                var query: String
                if productID == "bucket" { query = "completeBucket" }
                else { query = "bucket" }
                
                return PostNetworkManager.completeTogglePost(query: CompleteToggleQuery(product_id: query), id: postID)
            }
            .subscribe(with: self) { owner, result in
                successSignal.accept(())
            }
            .disposed(by: disposeBag)
        
        
        return Output(successSignal: successSignal.asDriver(onErrorJustReturn: ()))
    }
    
    
}
