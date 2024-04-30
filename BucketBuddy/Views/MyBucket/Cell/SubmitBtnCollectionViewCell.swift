//
//  SubmitBtnCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import UIKit

class SubmitBtnCollectionViewCell: BaseCollectionViewCell {
    
    let submitBtn = RegularButton(text: "완료")
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(submitBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        submitBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}
