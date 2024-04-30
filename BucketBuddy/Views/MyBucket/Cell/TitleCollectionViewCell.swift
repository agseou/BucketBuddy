//
//  TitleCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import UIKit

class TitleCollectionViewCell: BaseCollectionViewCell {
    
    private let titleTextField =  {
        let view = UITextField()
        view.placeholder = "title"
        view.borderStyle = .roundedRect
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(titleTextField)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}
