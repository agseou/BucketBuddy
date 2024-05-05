//
//  ProfileImageView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit
import Kingfisher

class ProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        setupImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2 // 원형 모양 생성
    }
    
    private func setupImageView() {
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        self.backgroundColor = .lightGray
        self.image = UIImage(resource: .monkey)
    }
    
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    func loadImage(from url: String) {
        if let completeURL = URL(string: APIKey.baseURL.rawValue + url) {
            self.kf.setImage(with: completeURL, placeholder: UIImage(resource: .monkey), options: [.transition(.fade(0.2))])
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
