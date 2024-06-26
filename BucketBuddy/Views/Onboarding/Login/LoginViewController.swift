//
//  LoginViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "버킷버디"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .black)
        return label
    }()
    let emailTextField = LoginTextField(placeholderText: "이메일을 입력해주세요.")
    let passwordTextField = LoginTextField(placeholderText: "비밀번호를 입력해주세요.")
    let loginBtn = RegularButton(text: "로그인")
    let signUpBtn = RegularButton(text: "회원가입")
    
    let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DefaultUDManager.shared.nickname = ""
        DefaultUDManager.shared.password = ""
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginBtn)
        view.addSubview(signUpBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        loginBtn.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        signUpBtn.snp.makeConstraints {
            $0.top.equalTo(loginBtn.snp.bottom).offset(15)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        let input = LoginViewModel.Input(
            email: emailTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            loginTap: loginBtn.rx.tap.asObservable()
        )
        
        let output = loginViewModel.transform(input: input)
        
        output.loginVaildation
            .drive(with: self) { owner, value in
                owner.loginBtn.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output.loginSuccess
            .drive(with: self) { owner, _ in
                DefaultUDManager.shared.isAccessed = true
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = scene.delegate as? SceneDelegate else { return }
                let vc = TabBarViewController()
                sceneDelegate.window?.rootViewController = vc
                sceneDelegate.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, message in
                if let message = message {
                    owner.showAlert(title: "로그인 실패", message: message)
                }
            }
            .disposed(by: disposeBag)
        
        signUpBtn.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SetUpEmailViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
