//
//  BucketListTableViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BucketListTableViewCell: BaseTableViewCell {
    
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
    
    var postID: String! = nil
    var productID: String! = nil
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(deadline)
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
    }
    
    func configureCell(title: String, deadline: String, postID: String, productID: String){
        self.title.text = title
        self.deadline.text = deadline.Ddays()
        self.postID = postID
        self.productID = productID
        
    }
}
