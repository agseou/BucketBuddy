//
//  WriteCommentsViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class WriteCommentsViewModel: CommonViewModel {
    
    struct Input {
        let tapSubmitBtn: Observable<Void>
        let comment: Observable<String>
        let id: Observable<String>
    }
    
    struct Output{
        let successResult: Driver<Void>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let successResult = PublishRelay<Void>()
        let commentAndId = Observable.combineLatest(input.comment, input.id)
        
        input.tapSubmitBtn
            .withLatestFrom(commentAndId)
            .flatMapLatest { (comment, id) in
                print("tap")
                return CommentNetworkManager.writeComments(query: CommentQuery(content: comment), id: id)
            }
            .subscribe(with: self) { owner, result in
                successResult.accept(())
            }
            .disposed(by: disposeBag)
        
        
        return Output(successResult: successResult.asDriver(onErrorJustReturn: ()))
    }
    
}
