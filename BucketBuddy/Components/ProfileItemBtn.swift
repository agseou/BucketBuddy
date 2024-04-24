//
//  FollowingBtn.swift
//  BucketBuddy
//
//  Created by eunseou on 4/24/24.
//

import UIKit

class ProfileItemBtn: UIButton {
    
    private let numberLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(number: Int, description: String) {
        super.init(frame: .zero)
        numberLabel.text = "\(number)"
        descriptionLabel.text = description
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        numberLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.font = .systemFont(ofSize: 14)
        
        addSubview(numberLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        numberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberLabel.snp.bottom).offset(5)
        }
    }
    
    func update(number: Int, description: String) {
        numberLabel.text = String(number)
        descriptionLabel.text = description
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
