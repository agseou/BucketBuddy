//
//  MyProfileView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit

final class MyProfileView: BaseView {

    private let profileImage = ProfileImageView(frame: .zero)
    private let userName = {
       let label = UILabel()
        label.text = "끼끼"
        return label
    }()

    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(profileImage)
        addSubview(userName)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImage.snp.makeConstraints {
            $0.left.equalTo(self).offset(20)
            $0.size.equalTo(80)
            $0.top.equalTo(self).offset(20)
        }
        userName.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.right).offset(15)
            $0.top.equalTo(profileImage.snp.top).offset(10)
            $0.width.equalTo(100)
        }
    }
}
