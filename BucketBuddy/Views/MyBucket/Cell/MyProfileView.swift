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
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 10
        return view
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
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(profileImage)
        addSubview(userName)
        addSubview(stackView)
        addSubview(followUserBtn)
        stackView.addArrangedSubview(followerBtn)
        stackView.addArrangedSubview(followingBtn)
    }
    
    override func configureView() {
        super.configureView()
        
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
        stackView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(100)
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
        
        Observable.merge(
            followerBtn.rx.tap.asObservable(),
            followingBtn.rx.tap.asObservable()
        )
        .subscribe(with: self) { owner, _ in
            owner.delegate?.didTapFollowerViewBtn()
        }
        .disposed(by: disposeBag)
        
        fetchTrigger.onNext(())
        
    }
}

protocol MyProfileViewDelegate: AnyObject {
    func didTapFollowerViewBtn()
    func didTapFollowingBtn()
}
