//
//  SignUpViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import UIKit
import SnapKit
import TextFieldEffects
import RxSwift
import RxCocoa

final class SetUpNicknameViewController: BaseViewController {
    
    // MARK: - Components
    private let titleLabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let nickNameTextField = {
        let view = HoshiTextField()
        view.borderActiveColor = .customBlue
        view.borderInactiveColor = .gray
        view.placeholder = "닉네임"
        return view
    }()
    private let nextBtn = RegularButton(text: "다음")
    
    // MARK: - Properties
    private var joinViewModel = JoinViewModel()
    private var setUpNicknameViewModel = SetUpNicknameViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        DispatchQueue.main.async {
            self.nickNameTextField.becomeFirstResponder()
        }
        registerKeyboardNotifications()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(nextBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
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
            email: Observable.just(DefaultUDManager.shared.email),
            password: Observable.just(DefaultUDManager.shared.password),
            nickname: nickNameTextField.rx.text.asObservable() ,
            joinTap: nextBtn.rx.tap.asObservable()
        )
        
        let joinOutput = joinViewModel.transform(input: joinInput)
        
        joinOutput.joinSuccess
            .drive(with: self) { owner, message in
                owner.showAlert(title: "회원가입 성공", message: "로그인 해주세요!") {
                    owner.navigationController?.popToRootViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        joinOutput.errorMessage
            .drive(with: self) { owner, message in
                if let message = message {
                    owner.showAlert(title: "회원가입 실패", message: message) {
                        owner.navigationController?.popToRootViewController(animated: true)
                    }
                }
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
