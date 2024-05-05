//
//  PostHeaderView.swift
//  BucketBuddy
//
//  Created by eunseou on 5/5/24.
//

import UIKit

class PostHeaderView: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    private let memoLabel = UILabel()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    private let postImageView = UIImageView()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(postImageView)
    }
    
    override func configureView() {
        super.configureView()
        titleLabel.font = .boldSystemFont(ofSize: 18)
        memoLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 12)
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        postImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(10)
        }
        
        likeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    @objc private func likeButtonTapped() {
        print("Like button tapped")
    }
    
    func configure(with title: String, memo: String, date: String, imageUrl: String) {
        titleLabel.text = title
        memoLabel.text = memo
        dateLabel.text = date
        if let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url) {
            postImageView.image = UIImage(data: imageData)
        }
    }
}
