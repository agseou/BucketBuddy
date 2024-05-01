//
//  EditProfileViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {

    
    private let profileImage = ProfileImageView(image: .monkey)
    private let nicknameLabel = {
        let label = UILabel()
        label.text = "닉네임"
        return label
    }()
    private let nicknameTextField = {
        let textField = UITextField()
        textField.text = DefaultUDManager.shared.nickname
        return textField
    }()
    private let emailLabel = {
        let label = UILabel()
        label.text = "이메일: \(DefaultUDManager.shared.email)"
        return label
    }()
    private let submitBtn = RegularButton(text: "완료")
    private var disposeBag = DisposeBag()
    let editMyProfileViewModel = EditMyProfileViewModel()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(profileImage)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(emailLabel)
        view.addSubview(submitBtn)
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
            $0.leading.equalTo( nicknameLabel.snp.trailing).offset(25)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        submitBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    override func setupBind() {
        super.setupBind()
        
        let editProfileQueryObservable = submitBtn.rx.tap
            .map { [weak self] in
                EditProfileQuery(nick: self?.nicknameTextField.text ?? DefaultUDManager.shared.nickname)
            }.asObservable()
        
        let input = EditMyProfileViewModel.Input(editQuery: editProfileQueryObservable)
        
        let output = editMyProfileViewModel.transform(input: input)
        
        output.successResult
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

}
