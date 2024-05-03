//
//  UploadImageViewModel.swift
//  BucketBuddy
//
//  Created by eunseou on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa

class UploadImagesViewModel: CommonViewModel {
    
    struct Input {
        let uploadData: Observable<Data>
    }
    
    struct Output{
        let profileResult: Driver<uploadImageModel>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let profileResult = PublishRelay<uploadImageModel>()
        
        input.uploadData
            .flatMapLatest { data in
                PostNetworkManager.uploadImage(query: uploadIamgeQuery(files: data))
            }.subscribe(with: self) { owner, result in
                profileResult.accept(result)
            }
            .disposed(by: disposeBag)
        
        return Output(profileResult: profileResult.asDriver(onErrorJustReturn: uploadImageModel.init(files: [])))
    }
    
}
