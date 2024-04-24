//
//  FetchMyProfile.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class FetchMyProfileViewModel: CommonViewModel {
    
    struct Input {
        let fetchTrigger: Observable<Void>
    }
    
    struct Output{
        
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
        Output()
    }
    
}
