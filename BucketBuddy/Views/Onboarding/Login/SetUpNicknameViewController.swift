//
//  SignUpViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SetUpNicknameViewController: BaseViewController {

    // MARK: - Components
    let titleL = {
        let label = UILabel()
        label.text = "이름을 입력해주세요!"
        return label
    }()
    let emailTextField = LoginTextField(placeholderText: "email")
    let nextBtn = RegularButton(text: "다음")
    
    // MARK: - Properties
    let nicknameViewmodel = SetUpNicknameViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Functions
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleL)
        view.addSubview(emailTextField)
        view.addSubview(nextBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleL.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleL.snp.bottom).offset(30)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        nextBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        nextBtn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                //
            }
            .disposed(by: disposeBag)
            
    }
}
