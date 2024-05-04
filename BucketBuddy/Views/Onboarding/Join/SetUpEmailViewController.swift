//
//  SetupEmailViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import TextFieldEffects
import RxSwift
import RxCocoa

final class SetUpEmailViewController: BaseViewController {
    
    // MARK: - Components
    private let titleLabel = {
        let label = UILabel()
        label.text = "이메일을 입력해주세요"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let emailTextField = {
        let view = HoshiTextField()
        view.tintColor = .gray
        view.borderActiveColor = .customBlue
        view.borderInactiveColor = .gray
        view.placeholder = "이메일"
        return view
    }()
    private let emailValidationBtn = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .medium
        config.title = "확인"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        btn.configuration = config
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 8.0
        return btn
    }()
    private let noticeLabel = {
        let label = UILabel()
        label.text = "이메일을 입력해주세요"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    private let nextBtn = RegularButton(text: "다음")
    
    // MARK: - Properties
    private var keyboardHeight: CGFloat = 0
    private let checkEmailValidationViewModel = CheckEmailValidationViewModel()
    private let setUpEmailViewModel = SetUpEmailViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        DispatchQueue.main.async {
            self.emailTextField.becomeFirstResponder()
        }
        registerKeyboardNotifications()
    }
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailValidationBtn)
        view.addSubview(noticeLabel)
        view.addSubview(nextBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.height.equalTo(50)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        emailValidationBtn.snp.makeConstraints {
            $0.centerY.equalTo(emailTextField)
            $0.height.equalTo(40)
            $0.left.equalTo(emailTextField.snp.right).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.height.equalTo(40)
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
                let vc = SetUpPasswordViewController()
                owner.navigationController?.pushViewController(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        let checkEmailInput = CheckEmailValidationViewModel.Input(
            email: emailTextField.rx.text.orEmpty.asObservable(),
            tapEmailValidatoinBtn: emailValidationBtn.rx.tap.asObservable())
        
        let checkEmailOutput = checkEmailValidationViewModel.transform(input: checkEmailInput)
        
        checkEmailOutput.validationResult
            .drive(with: self) { owner, value in
                owner.noticeLabel.text = value
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
