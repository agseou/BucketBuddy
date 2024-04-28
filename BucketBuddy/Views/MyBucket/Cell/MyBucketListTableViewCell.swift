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
        label.text = "test"
        return label
    }()
    private let deadline = {
        let label = UILabel()
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
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        container.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self).inset(10)
            $0.verticalEdges.equalTo(self).inset(5)
        }
        title.snp.makeConstraints {
            $0.top.equalTo(container)
            $0.leading.equalTo(container).offset(10)
        }
        deadline.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom)
            $0.leading.equalTo(title.snp.trailing)
        }
        editBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(container)
        }
        checkBtn.snp.makeConstraints {
            $0.bottom.trailing.equalTo(container)
        }
    }
    
    override func setBind() {
        super.setBind()
        
        editBtn.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showEditMenu()
            }
            .disposed(by: disposeBag)
    }
    
    func configureCell(title: String, deadline: String, postID: String){
        self.title.text = title
        self.deadline.text = deadline
        self.postID = postID
    }
    
    func showEditMenu() {
        let editAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { action in
            // 수정 관련 로직
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
