//
//  fetchMyBucketListViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class FetchMyBucketListViewModel: CommonViewModel {
    
    struct Input {
        let fetchTrigger: Observable<Void>
    }
    
    struct Output{
        let postResult: Driver<FetchPostModel>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let postResult = PublishRelay<FetchPostModel>()
        
        input.fetchTrigger
            .flatMapLatest { _ in
               return PostNetworkManager.fetchUserPost(query: FetchPostQuery(next: nil, limit: nil, product_id: ""), userID: DefaultUDManager.shared.userID)
            }
            .subscribe(with: self) { owner, result in
                postResult.accept(result)
            }
            .disposed(by: disposeBag)
        
        
        return Output(postResult: postResult.asDriver(onErrorJustReturn: FetchPostModel(data: [], next_cursor: "0")))
    }
    
}
