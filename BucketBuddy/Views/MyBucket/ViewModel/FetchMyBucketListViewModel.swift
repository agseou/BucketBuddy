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
                switch result {
                case .success(let success):
                    postResult.accept(success)
                case .badRequest:
                    print("잘못된 요청값입니다.")
                case .unauthorized:
                    print("유효하지 않은 액세스 토큰")
                case .forbidden:
                    print("접근권한 없음")
                case .expiredAccessToken:
                    print("에러 발생: 엑세스 토큰 만료")
                case .error(let error):
                    print("!!!에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(postResult: postResult.asDriver(onErrorJustReturn: FetchPostModel(data: [], next_cursor: "0")))
    }
    
}
