//
//  PagingTabBarCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/28/24.
//

import UIKit
import SnapKit

class PagingTabBarCell: BaseCollectionViewCell {
    static let identifier = "PagingTabBarCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var underline: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemPink
        view.alpha = 0.0
        
        return view
    }()
    
    override var isSelected: Bool {
        // Cell이 선택 되었을 때 설정
        didSet {
            titleLabel.textColor = isSelected ? .black : .secondaryLabel
            underline.alpha = isSelected ? 1.0 : 0.0
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [titleLabel, underline].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        underline.snp.makeConstraints {
            $0.height.equalTo(3.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupView(title: String) {
        
        titleLabel.text = title
    }
}
