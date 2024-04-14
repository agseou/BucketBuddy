//
//  SignUpViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import UIKit
import SnapKit

class SignUpViewController: BaseViewController {

    let titleL = {
        let label = UILabel()
        label.text = "회원가입"
        return label
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleL)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleL.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
    }
}
