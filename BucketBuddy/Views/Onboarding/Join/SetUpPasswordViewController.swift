//
//  SetupPasswordViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import TextFieldEffects
import RxSwift
import RxCocoa

final class SetUpPasswordViewController: BaseViewController {

    // MARK: - Components
    private let titleLabel = {
        let label = UILabel()
        label.text = "비밀번호를 입력해주세요"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let passwordTextField = {
        let view = HoshiTextField()
        view.tintColor = .gray
        view.borderActiveColor = .customBlue
        view.borderInactiveColor = .gray
        view.placeholder = "비밀번호"
        return view
    }()
    private let checkPasswordTextField = {
        let view = HoshiTextField()
        view.tintColor = .gray
        view.borderActiveColor = .customBlue
        view.borderInactiveColor = .gray
        view.placeholder = "비밀번호 확인"
        return view
    }()
    private let nextBtn = RegularButton(text: "다음")

    // MARK: - Properties
    private var setupPasswordViewModel = SetupPasswordViewModel()
    private let disposeBag = DisposeBag()

    
    // MARK: - Functions    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        DispatchQueue.main.async {
            self.passwordTextField.becomeFirstResponder()
        }
        registerKeyboardNotifications()
    }
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(checkPasswordTextField)
        view.addSubview(nextBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
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
        
        output.passwordVaildation
            .drive(with: self) { owner, isEnabled in
                owner.nextBtn.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        output.checkPasswordVaildation
            .drive(with: self) { owner, isEnabled in
                owner.nextBtn.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                DefaultUDManager.shared.password = owner.passwordTextField.text ?? ""
                let vc = SetUpNicknameViewController()
                owner.navigationController?.pushViewController(vc, animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    private func registerKeyboardNotifications() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
           guard let userInfo = notification.userInfo,
                 let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                 let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

           let keyboardHeight = keyboardFrame.height
            nextBtn.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight)
            }

           UIView.animate(withDuration: duration) {
               self.view.layoutIfNeeded()
           }
       }

       @objc private func keyboardWillHide(_ notification: Notification) {
           guard let userInfo = notification.userInfo,
                 let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

           nextBtn.snp.updateConstraints {
                   $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
               }

           UIView.animate(withDuration: duration) {
               self.view.layoutIfNeeded()
           }
       }
}
