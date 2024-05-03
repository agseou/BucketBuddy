//
//  EditProfileViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import YPImagePicker

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
        textField.placeholder = "수정할 닉네임을 입력하세요!"
        return textField
    }()
    private let emailLabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    private let emailInfoLabel = {
        let label = UILabel()
        label.text = DefaultUDManager.shared.email
        return label
    }()
    private let submitBtn = RegularButton(text: "완료")
    
    private var disposeBag = DisposeBag()
    private let uploadImagesViewModel = UploadImagesViewModel()
    private let editMyProfileViewModel = EditMyProfileViewModel()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(profileImage)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailInfoLabel)
        view.addSubview(submitBtn)
    }
    
    
    override func configureView() {
        super.configureView()
        
        navigationItem.title = "프로필 수정"
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tapGesture)
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
        }
        emailInfoLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            $0.leading.equalTo(emailLabel.snp.trailing).offset(25)
        }
        
        submitBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        let input = EditMyProfileViewModel.Input(
            nickname:nicknameTextField.rx.text.orEmpty.asObservable(),
            profileImage: Observable.just(""),
            submitBtnTap: submitBtn.rx.tap.asObservable())
        
        let output = editMyProfileViewModel.transform(input: input)
        
        output.successResult
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func profileImageTapped() {
        showImagePicker()
    }
    
    private func showImagePicker() {
            var config = YPImagePickerConfiguration()
            config.screens = [.library, .photo] // 앨범 카메라 접근
            config.library.mediaType = .photo
            config.showsCrop = .rectangle(ratio: 1.0) // 1:1 비율 크롭

            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [weak self, unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self?.profileImage.image = photo.image
                    self?.uploadImage(photo.image) // 이미지 업로드 함수 호출
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
        
    private func uploadImage(_ image: UIImage) {
        guard let imageData = image.pngData() else { return } // PNG 데이터로

        let uploadVM = UploadImagesViewModel()
           let uploadInput = UploadImagesViewModel.Input(uploadData: Observable.just(imageData))
           let uploadOutput = uploadVM.transform(input: uploadInput)

           uploadOutput.profileResult
            .drive(with: self) { owner, uploadModel in
                //여기서받아오는 uploadModel의 값을 setBind의 input의 profileImage에 넣고싶어
                
            }.disposed(by: disposeBag)
    }
 
}
