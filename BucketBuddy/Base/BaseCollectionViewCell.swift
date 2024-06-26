//
//  BaseCollectionViewCell.swift
//  BucketBuddy
//
//  Created by 은서우 on 4/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseCollectionViewCell: UICollectionViewCell, BaseViewProtocol {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureView()
        setConstraints()
        setBind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configureHierarchy() { }
    func configureView() { }
    func setConstraints() { }
    func setBind() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
