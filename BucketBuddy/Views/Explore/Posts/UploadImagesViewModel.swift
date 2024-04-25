//
//  UploadImagesViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa
class UploadImagesViewModel: CommonViewModel {
    
    struct Input {
        let files: Observable<Data>
    }
    struct Output {
        let uploadImagesResults: Driver<[String]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let uploadImagesResults = PublishRelay<[String]>()
        
        input.files
            .map { query in
                uploadIamgeQuery(files: query)
            }
            .flatMapLatest { query in
                PostNetworkManager.uploadImage(query: query)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    uploadImagesResults.accept(success.files)
                case .badRequest:
                    print("입력값 확인")
                case .unauthorized:
                    print("유효하지 않은 액세스 토큰 입니다.")
                case .forbidden:
                    print("입력값 확인")
                case .expiredAccessToken:
                    print("엑세스 토큰 만료 -> refresh")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(uploadImagesResults: uploadImagesResults.asDriver(onErrorJustReturn: []))
    }
    
}
