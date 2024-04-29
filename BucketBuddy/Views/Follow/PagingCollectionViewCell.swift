//
//  PagingCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/28/24.
//

import UIKit

class PagingCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PagingCollectionViewCell"
       
       private lazy var contentLabel: UILabel = {
           let label = UILabel()
           
           label.font = .systemFont(ofSize: 36.0, weight: .bold)
           label.textAlignment = .center
           label.backgroundColor = [.systemOrange, .systemPurple, .systemCyan, .systemMint, .systemBrown, .systemYellow].randomElement()
           
           return label
       }()
       
       func setupView(title: String) {
           setupLayout()
           contentLabel.text = title
       }
    
}

private extension PagingCollectionViewCell {
    func setupLayout() {
        [
            contentLabel
        ].forEach { addSubview($0) }
        
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
