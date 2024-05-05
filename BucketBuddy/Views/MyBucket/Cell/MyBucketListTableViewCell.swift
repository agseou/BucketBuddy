//
//  MyBucketListTableViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


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
        btn.tintColor = .black
        return btn
    }()
    private let checkBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    var postID: String! = nil
    var productID: String! = nil
    var onCompleteTapped: ((String, String) -> Void)?
    var onEditTapped: ((String) -> Void)?
    var onDeleteTapped: ((String) -> Void)?
    let completeToggleViewModel = CompleteToggleViewModel()
    
    
    // MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
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
            $0.top.equalTo(container).offset(10)
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
            .bind(with: self) { owner, _ in
                guard let postID = owner.postID else { return }
                owner.onEditTapped?(postID)
            }
            .disposed(by: disposeBag)
        
       
    }
    
    func configureCell(title: String, deadline: String, postID: String, productID: String){
        self.title.text = title
        self.deadline.text = deadline.Ddays()
        self.postID = postID
        self.productID = productID
        if productID == "bucket" {
            self.container.backgroundColor = .systemGray6
        } else {
            self.container.backgroundColor = .gray
        }
        
        checkBtn.rx.tap
            .bind(with: self) { owner, _ in
                guard let postID = owner.postID, let productID = owner.productID else { return }
                self.onCompleteTapped?(productID, postID)
            }
            .disposed(by: disposeBag)
    }
    
    func showEditMenu() {
            let editAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] action in
                guard let self = self, let postID = self.postID else { return }
                self.onEditTapped?(postID)
            }
            let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
                guard let self = self, let postID = self.postID else { return }
                self.onDeleteTapped?(postID)
            }

            let menu = UIMenu(title: "", children: [editAction, deleteAction])
            editBtn.showsMenuAsPrimaryAction = true
            editBtn.menu = menu
        }
    
}
