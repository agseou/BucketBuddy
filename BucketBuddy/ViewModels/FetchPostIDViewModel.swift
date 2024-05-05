//
//  FetchCommentsViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class FetchPostIDViewModel: CommonViewModel {
    
    struct Input {
        let fetchTrigger: Observable<String>
    }
    
    struct Output{
        let postModel: Driver<PostModel>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let postModel = PublishRelay<PostModel>()
        
        input.fetchTrigger
            .flatMapLatest { id in
                return PostNetworkManager.fetchPostDetail(id: id)
            }
            .subscribe(with: self) { owner, result in
                dump(result)
                postModel.accept(result)
            }
            .disposed(by: disposeBag)
        
      
        return Output(postModel: postModel.asDriver(onErrorJustReturn: PostModel.defaultPostModel ))
    }
    
}
