//
//  FollowerListTableViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift

class FollowerListTableViewCell: BaseTableViewCell {

    private let profileImage = ProfileImageView(frame: .zero)
    private let nickname = {
        let label = UILabel()
        return label
    }()
    private let followBtn = {
        let btn = UIButton()
        btn.setTitle("팔로우", for: .normal)
        return btn
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(profileImage)
        addSubview(nickname)
        addSubview(followBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        nickname.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.right).offset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
        }
        followBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    func update(image: UIImage, nickname: String) {
        profileImage.setImage(image)
        self.nickname.text = nickname
    }

}
