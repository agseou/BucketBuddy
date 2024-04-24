//
//  SegmentControlCollectionReusableView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/22/24.
//

import UIKit

class SegmentControlCollectionReusableView: UICollectionReusableView {
        
    private let segmentControl = CapsuleSegmentedControl(items: ["전체", "미완료", "완료"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        setConstraints()
    }
    
    private func configureHierarchy() {
        addSubview(segmentControl)
    }
    
    private func setConstraints() {
        segmentControl.snp.makeConstraints {
            $0.verticalEdges.equalTo(self).inset(20)
            $0.horizontalEdges.equalTo(self).inset(30)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
