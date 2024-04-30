//
//  DateCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import UIKit
import SnapKit

class DateCollectionViewCell: BaseCollectionViewCell {
    
    let datelabel = {
        let label = UILabel()
        label.text = "마감일 선택"
        return label
    }()
    let toggle = UISwitch()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        toggle.isOn = false
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(datelabel)
        addSubview(toggle)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        datelabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
