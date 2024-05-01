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

final class SetUpNicknameViewController: BaseViewController {
    
    // MARK: - Components
    private let titleL = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요!"
        return label
    }()
    private let nickNameTextField = LoginTextField(placeholderText: "nickname")
    private let nextBtn = RegularButton(text: "다음")
    
    // MARK: - Properties
    private var joinViewModel: JoinViewModel
    private var setUpNicknameViewModel = SetUpNicknameViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Functions
    init(joinViewModel: JoinViewModel) {
        self.joinViewModel = joinViewModel
        super.init()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleL)
        view.addSubview(nickNameTextField)
        view.addSubview(nextBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleL.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        nickNameTextField.snp.makeConstraints {
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
        
        let nickInput = SetUpNicknameViewModel.Input(nickname: nickNameTextField.rx.text.orEmpty.asObservable())
        let nickOutput = setUpNicknameViewModel.transform(input: nickInput)
        
        nickOutput.nicknameVaildation
            .drive(with: self) { owner, isEnabled in
                owner.nextBtn.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        
        let joinInput = JoinViewModel.Input(
            email: joinViewModel.emailRelay.asObservable(),
            password: joinViewModel.passwordRelay.asObservable(),
            nickname: nickNameTextField.rx.text.asObservable(),
            joinTap: nextBtn.rx.tap.asObservable()
        )
        let joinOutput = joinViewModel.transform(input: joinInput)
        
        joinOutput.joinSuccess
            .drive(with: self) { owner, message in
                owner.showAlert(title: "회원가입 성공", message: "로그인 해주세요!")
                
            }
            .disposed(by: disposeBag)
        
        joinOutput.errorMessage
            .drive(with: self) { owner, message in
                if let message = message {
                    owner.showAlert(title: "회원가입 실패", message: message)
                }
            }
            .disposed(by: disposeBag)
    }
}
