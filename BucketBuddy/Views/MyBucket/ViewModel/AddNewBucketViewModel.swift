//
//  AddNewBucketViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class AddNewBucketViewModel: CommonViewModel {
    
    struct Input {
        let title: Observable<String>
        let tags: Observable<String>
        let memo: Observable<String>
    //    let
        let summitTap: Observable<Void>
    }
    
    struct Output {
        let summitResult: Driver<Void>
        let errorMessage: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let summitResult = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        
        let postObservable = Observable.combineLatest(input.title, input.tags, input.memo)
            .map { (title, tags, memo) in
                return WritePostQuery(title: title, content: tags, content1: memo, content2: nil, content3: nil, content4: nil, content5: nil, product_id: "bucket", files: nil)
            }
        
        input.summitTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(postObservable)
            .flatMapLatest { query in
                PostNetworkManager.writePost(query: query)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    summitResult.accept(())
                case .unauthorized:
                    print("유효하지 않은 액세스 토큰 입니다.")
                case .forbidden:
                    print("입력값 확인")
                case .nonePost:
                    errorMessage.accept("서버 오류로 포스트가 업로드 되지않았습니다.")
                case .expiredAccessToken:
                    print("엑세스 토큰 만료 -> refresh")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(summitResult: summitResult.asDriver(onErrorJustReturn: ()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
}

