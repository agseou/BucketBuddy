//
//  DetailPostViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit

final class DetailPostViewController: BaseViewController {

    private let commentTableView = {
        let tableView = UITableView()
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        return tableView
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(commentTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        commentTableView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
