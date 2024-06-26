//
//  CommentsTableViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit

class CommentsTableViewCell: BaseTableViewCell {
    
    private let profileImage = ProfileImageView(frame: .zero)
    private let nickname = {
        let label = UILabel()
        label.text = "nickname"
        return label
    }()
    private let comments = {
        let label = UILabel()
        label.text = "comment"
        return label
    }()
    private let date = {
        let label = UILabel()
        label.text = "date"
        return label
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(profileImage)
        contentView.addSubview(nickname)
        contentView.addSubview(comments)
        contentView.addSubview(date)
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImage.snp.makeConstraints {
            $0.top.left.equalTo(contentView).offset(10)
            $0.size.equalTo(50)
            $0.bottom.lessThanOrEqualTo(contentView).offset(-10).priority(.high)
        }
        nickname.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.right).offset(10)
            $0.right.equalTo(contentView).inset(10)
            $0.top.equalTo(profileImage)
        }
        comments.snp.makeConstraints {
            $0.left.equalTo(nickname)
            $0.right.equalTo(contentView).inset(10)
            $0.top.equalTo(nickname.snp.bottom).offset(5)
            $0.bottom.lessThanOrEqualTo(contentView).offset(-10).priority(.high)
        }
        date.snp.makeConstraints {
            $0.left.equalTo(nickname)
            $0.top.equalTo(comments.snp.bottom).offset(5)
            $0.bottom.equalTo(contentView).offset(-10)
        }
    }
    
    func configureCell(nickname: String, comment: String, date: String, profileImageURL: String) {
        self.nickname.text = nickname
        self.comments.text = comment
        self.date.text = date
        self.profileImage.loadImage(from: profileImageURL)
    }
}
