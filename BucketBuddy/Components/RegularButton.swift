//
//  RegularButton.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import UIKit

class RegularButton: UIButton {

    init(text: String) {
        super.init(frame: .zero)
         var config = UIButton.Configuration.filled()
         config.title = text
         config.baseBackgroundColor = .customNavy
         config.baseForegroundColor = .white
         configuration = config
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
