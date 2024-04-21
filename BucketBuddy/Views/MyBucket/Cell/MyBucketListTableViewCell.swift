//
//  MyBucketListTableViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/19/24.
//

import UIKit

final class MyBucketListTableViewCell: BaseCollectionViewCell {

    // MARK: - Components
    private let container = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    private let icon = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart")
        return view
    }()
    private let title = {
        let label = UILabel()
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
    
    // MARK: - Functions
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(container)
        container.addSubview(icon)
        container.addSubview(title)
        container.addSubview(deadline)
        container.addSubview(editBtn)
        container.addSubview(checkBtn)
    }
    
    override func configureView() {
        super.configureView()
        
        self.backgroundColor = .clear
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        container.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self).inset(10)
            $0.verticalEdges.equalTo(self).inset(5)
        }
        icon.snp.makeConstraints {
            $0.top.leading.equalTo(container)
        }
        title.snp.makeConstraints {
            $0.top.equalTo(container)
            $0.leading.equalTo(icon.snp.trailing)
        }
        deadline.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom)
            $0.leading.equalTo(icon.snp.trailing)
        }
        editBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(container)
        }
        checkBtn.snp.makeConstraints {
            $0.bottom.trailing.equalTo(container)
        }
    }
    
    func configureCell(icon: String, title: String, deadline: String){
        self.icon.image = UIImage(named: icon)
        self.title.text = title
        self.deadline.text = deadline
    }

}
