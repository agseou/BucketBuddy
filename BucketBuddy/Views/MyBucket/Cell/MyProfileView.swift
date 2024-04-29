//
//  MyProfileView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyProfileView: BaseCollectionViewCell {
    
    private let profileImage = ProfileImageView(frame: .zero)
    private let userName = {
        let label = UILabel()
        label.text = "끼끼"
        return label
    }()
    private let followUserBtn = {
        let btn = UIButton()
        btn.setTitle("팔로우", for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    private let followerBtn = ProfileItemBtn(number: 0, description: "팔로워")
    private let followingBtn = ProfileItemBtn(number: 0, description: "팔로잉")
    
    weak var delegate: MyProfileViewDelegate?
    let fetchMyProfileViewModel = FetchMyProfileViewModel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(profileImage)
        addSubview(userName)
        addSubview(followUserBtn)
        addSubview(followerBtn)
        addSubview(followingBtn)
    }
    
    override func configureView() {
        super.configureView()
        
        followerBtn.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        followingBtn.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton() {
        delegate?.didTapFollowViewBtn()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImage.snp.makeConstraints {
            $0.left.equalTo(self).offset(20)
            $0.size.equalTo(80)
            $0.top.equalTo(self).offset(20)
        }
        userName.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.right).offset(15)
            $0.top.equalTo(profileImage.snp.top).offset(10)
            $0.width.equalTo(100)
        }
        followUserBtn.snp.makeConstraints {
            $0.left.equalTo(userName.snp.right).offset(10)
            $0.top.equalTo(profileImage.snp.top).offset(10)
        }
        followerBtn.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(50)
            $0.right.equalTo(followingBtn.snp.left)
            $0.centerY.equalTo(profileImage)
        }
        followingBtn.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(50)
            $0.right.equalToSuperview().inset(40) // 여백 조절
            $0.centerY.equalTo(profileImage)
        }
    }
    
    override func setBind() {
        super.setBind()
        
        let fetchTrigger = PublishSubject<Void>()
        
        let input = FetchMyProfileViewModel.Input(fetchTrigger: fetchTrigger.asObservable())
        let output = fetchMyProfileViewModel.transform(input: input)
        
        output.nickname
            .drive(userName.rx.text)
            .disposed(by: disposeBag)
        
        
        output.followerCnt
            .drive(with: self) { owner, value in
                owner.followerBtn.update(number: value, description: "팔로워")
            }
            .disposed(by: disposeBag)
        
        output.followingCnt
            .drive(with: self) { owner, value in
                owner.followingBtn.update(number: value, description: "팔로워")
            }
            .disposed(by: disposeBag)
        
        // rxswift로 되지 않는 문제 발생
//        followerBtn.rx.tap
//               .subscribe(with: self) { owner, _ in
//                   print("tap")
//                   owner.delegate?.didTapFollowViewBtn()
//               }
//               .disposed(by: disposeBag)
//
//        followingBtn.rx.tap
//               .subscribe(with: self) { owner, _ in
//                   print("tap")
//                   owner.delegate?.didTapFollowViewBtn()
//               }
//               .disposed(by: disposeBag)
        
    }
}

protocol MyProfileViewDelegate: AnyObject {
    func didTapFollowViewBtn()
}
