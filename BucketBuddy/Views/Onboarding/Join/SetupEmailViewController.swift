//
//  SetupEmailViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SetupEmailViewController: BaseViewController {
    
    // MARK: - Components
    private let titleL = {
        let label = UILabel()
        label.text = "이메일을 입력해주세요!"
        return label
    }()
    private let emailTextField = LoginTextField(placeholderText: "email")
    private let nextBtn = RegularButton(text: "다음")

    // MARK: - Properties
    private let setUpEmailViewModel = SetUpEmailViewModel()
    private let disposeBag = DisposeBag()
    
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
                DefaultUDManager.shared.email = owner.emailTextField.text ?? ""
                let vc = SetupPasswordViewController(joinViewModel: owner.joinViewModel)
                owner.navigationController?.pushViewController(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        let emailInput = SetUpEmailViewModel.Input(
            email: emailTextField.rx.text.orEmpty.asObservable())
        let emailOutput = setUpEmailViewModel.transform(input: emailInput)
        
        emailOutput.emailVaildation
            .drive(with: self) { owner, isEnabled in
                owner.nextBtn.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
    }
}
