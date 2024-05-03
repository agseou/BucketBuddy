//
//  SetupPasswordViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SetupPasswordViewController: BaseViewController {

    // MARK: - Components
    private let titleL = {
        let label = UILabel()
        label.text = "비밀번호를 입력해주세요!"
        return label
    }()
    private let passwordTextField = LoginTextField(placeholderText: "password")
    private let checkPasswordTextField = LoginTextField(placeholderText: "password")
    private let nextBtn = RegularButton(text: "다음")

    // MARK: - Properties
    private var setupPasswordViewModel = SetupPasswordViewModel()
    private let disposeBag = DisposeBag()

    
    // MARK: - Functions    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleL)
        view.addSubview(passwordTextField)
        view.addSubview(checkPasswordTextField)
        view.addSubview(nextBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleL.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(titleL.snp.bottom).offset(30)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
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
        
        let input = SetupPasswordViewModel.Input(
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            checkPassword: checkPasswordTextField.rx.text.orEmpty.asObservable())
        let output = setupPasswordViewModel.transform(input: input)
        
        nextBtn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                DefaultUDManager.shared.password = owner.passwordTextField.text ?? ""
                let vc = SetUpNicknameViewController(joinViewModel: owner.joinViewModel)
                owner.navigationController?.pushViewController(vc, animated: false)
            }
            .disposed(by: disposeBag)
    }
}
