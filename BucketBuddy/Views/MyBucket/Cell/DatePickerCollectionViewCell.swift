//
//  DatePickerCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import UIKit

class DatePickerCollectionViewCell: BaseCollectionViewCell {
    
    let datePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .inline
        view.minimumDate = Date()
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(datePicker)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        datePicker.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    
}
