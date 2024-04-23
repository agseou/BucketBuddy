//
//  MyProfileView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit

final class MyProfileView: BaseCollectionViewCell {
    
    private let profileImage = ProfileImageView(frame: .zero)
    private let userName = {
        let label = UILabel()
        label.text = "끼끼"
        return label
    }()
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 10
        return view
    }()
    private let followerLabel = {
        let label = UILabel()
        label.text = "팔로워"
        return label
    }()
    private let followingLabel = {
        let label = UILabel()
        label.text = "팔로잉"
        return label
    }()
    
    let profileInfo: [String:Int] = ["버킷리스트": 20, "팔로워": 10, "팔로잉": 22]
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(profileImage)
        addSubview(userName)
        addSubview(stackView)
    }
    
    override func configureView() {
        super.configureView()
        
        for (label, number) in profileInfo {
            let subStackView = createSubStackView(number: number, label: label)
            stackView.addArrangedSubview(subStackView)
        }
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
        stackView.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.right).offset(40)
            $0.right.equalTo(self).inset(40)
            $0.centerY.equalTo(profileImage)
        }
    }
    
    private func createSubStackView(number: Int, label: String) -> UIStackView {
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.alignment = .center
        subStackView.distribution = .fillProportionally
        subStackView.spacing = 0
        
        let numLabel = UILabel()
        numLabel.text = String(number)
        let explainLabel = UILabel()
        explainLabel.text = label
        
        subStackView.addArrangedSubview(numLabel)
        subStackView.addArrangedSubview(explainLabel)
        
        return subStackView
    }
}
