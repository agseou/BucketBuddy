//
//  AddTagCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import UIKit

class AddTagCollectionViewCell: BaseCollectionViewCell {
    
    let tagTextField =  {
        let view = UITextField()
        view.placeholder = "tag"
        view.borderStyle = .roundedRect
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(tagTextField)
    }
    
    override func setConstraints() {
        super.setConstraints()
        tagTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
    }

}
