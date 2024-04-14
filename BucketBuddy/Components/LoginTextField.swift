//
//  LoginTextField.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import UIKit

class LoginTextField: UITextField {

    init(placeholderText: String) {
        super.init(frame: .zero)
        
        borderStyle = .roundedRect
        placeholder = placeholderText
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
