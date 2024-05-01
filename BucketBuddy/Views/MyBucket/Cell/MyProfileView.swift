//
//  MyProfileView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyProfileView: BaseCollectionViewCell {
    
    private let profileImage = ProfileImageView(frame: .zero)
    private let userName = {
        let label = UILabel()
        label.text = "끼끼"
        return label
    }()
    private let followUserBtn = {
        let btn = UIButton()
        btn.setTitle("팔로우", for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    let followerBtn = ProfileItemBtn(number: 0, description: "팔로워")
    let followingBtn = ProfileItemBtn(number: 0, description: "팔로잉")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(profileImage)
        addSubview(userName)
        addSubview(followUserBtn)
        addSubview(followerBtn)
        addSubview(followingBtn)
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
        followUserBtn.snp.makeConstraints {
            $0.left.equalTo(userName.snp.right).offset(10)
            $0.top.equalTo(profileImage.snp.top).offset(10)
        }
        followerBtn.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(50)
            $0.right.equalTo(followingBtn.snp.left)
            $0.centerY.equalTo(profileImage)
        }
        followingBtn.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(50)
            $0.right.equalToSuperview().inset(40) // 여백 조절
            $0.centerY.equalTo(profileImage)
        }
    }
   
    func configureCell(nickname: String, followerCnt: Int, followingCnt: Int) {
        userName.text = nickname
        followerBtn.update(number: followingCnt, description: "팔로일")
        followerBtn.update(number: followerCnt, description: "팔로워")
    }
}
