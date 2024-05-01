//
//  MyBucketListTableViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol MyBucketListTableViewCellDelegate: AnyObject {
    func reloadTableView()
    func displayErrorMessage(_ message: String)
}

final class MyBucketListTableViewCell: BaseCollectionViewCell {
    
    // MARK: - Components
    private let container = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        return view
    }()
    private let title = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    private let deadline = {
        let label = UILabel()
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    private let editBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    private let checkBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        return btn
    }()
    
    var postID: String! = nil
    var productID: String! = nil
    
    let completeToggleViewModel = CompleteToggleViewModel()
    
    weak var delegate: MyBucketListTableViewCellDelegate?
    
    // MARK: - Functions
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(deadline)
        container.addSubview(editBtn)
        container.addSubview(checkBtn)
    }
    
    override func configureView() {
        super.configureView()
        showEditMenu()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        container.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self).inset(10)
            $0.verticalEdges.equalTo(self).inset(5)
        }
        title.snp.makeConstraints {
            $0.centerY.equalTo(container).offset(-10)
            $0.leading.equalTo(container).offset(10)
        }
        deadline.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.leading.equalTo(container).offset(10)
        }
        editBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(container).offset(10)
            $0.trailing.equalTo(container).inset(10)
        }
        checkBtn.snp.makeConstraints {
            $0.bottom.equalTo(container).inset(10)
            $0.trailing.equalTo(container).inset(10)
        }
    }
    
    override func setBind() {
        super.setBind()
        
        editBtn.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showEditMenu()
            }
            .disposed(by: disposeBag)
        
        checkBtn.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tapCheckBtn()
            }
            .disposed(by: disposeBag)
    }
    
    func tapCheckBtn() {
        
        let triggerObservable = Observable.just((productID!, postID!))
        
        let input = CompleteToggleViewModel.Input(trigger: triggerObservable)
        let output = completeToggleViewModel.transform(input: input)
        
        output.successSignal
            .drive(with: self) { owner, _ in
                owner.delegate?.reloadTableView()
            }
            .disposed(by: disposeBag)
            
        output.errorMessage
            .drive(with: self) { owner, message in
                owner.delegate?.displayErrorMessage(message)
            }
            .disposed(by: disposeBag)
    }
    
    func configureCell(title: String, deadline: String, postID: String, productID: String){
        self.title.text = title
        self.deadline.text = deadline.Ddays()
        self.postID = postID
        self.productID = productID
    }
    
    func showEditMenu() {
        let editAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { action in
            
        }
        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            PostNetworkManager.deletePost(postID: self.postID)
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success():
                        owner.delegate?.reloadTableView()
                    case .unauthorized:
                        print("유효하지 않은 액세스 토큰")
                    case .forbidden:
                        print("접근권한 없음")
                    case .nonePost:
                        print("이미 삭제된 포스트 입니다.")
                    case .expiredAccessToken:
                        print("에러 발생: 엑세스 토큰 만료")
                    case .error(let error):
                        print("에러 발생: \(error.localizedDescription)")
                    }
                }
                .disposed(by: self.disposeBag)
        }
        
        let menu = UIMenu(title: "", children: [editAction, deleteAction])
        editBtn.showsMenuAsPrimaryAction = true
        editBtn.menu = menu
    }
    
}
