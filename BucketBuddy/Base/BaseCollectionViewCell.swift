//
//  BaseCollectionViewCell.swift
//  BucketBuddy
//
//  Created by 은서우 on 4/10/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, BaseViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureView()
        setConstraints()
    }
    
    func configureHierarchy() { }
    func configureView() { }
    func setConstraints() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
