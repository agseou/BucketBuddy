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
        let memo: Observable<String>
        let summitTap: Observable<Void>
    }
    
    struct Output {
        let summitVaildation: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let summitVaildation = BehaviorRelay<Bool>(value: false)
       
        return Output(summitVaildation: summitVaildation.asDriver())
    }
}

