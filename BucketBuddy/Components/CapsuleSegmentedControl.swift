//
//  CapsuleSegmentedControl.swift
//  BucketBuddy
//
//  Created by eunseou on 4/19/24.
//

import UIKit

final class CapsuleSegmentedControl: UISegmentedControl {
    
    private lazy var radius: CGFloat = bounds.height / 2
    
    private var segmentInset: CGFloat = 0.1 {
        didSet{
            if segmentInset == 0 {
                segmentInset = 0.1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCapsuleSegmentedControl()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        configureCapsuleSegmentedControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.radius
        
        if let selectedImageView = subviews[numberOfSegments] as? UIImageView {
            
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil
            
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            
            selectedImageView.layer.cornerRadius = self.radius
            selectedImageView.layer.masksToBounds = true
        }
        
    }
    
    func configureCapsuleSegmentedControl() {
        
        configureDivider()
    }
    
    
    func configureDivider() {
        
        let image = UIImage()
        
        self.setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
