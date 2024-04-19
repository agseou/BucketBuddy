//
//  MyBucketViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyBucketViewController: BaseViewController {

    lazy var myBucketListTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = UIScreen.main.bounds.size.width * 0.3
        tableView.separatorStyle = .none
        tableView.register(MyBucketListTableViewCell.self, forCellReuseIdentifier: "MyBucketListTableViewCell")
        return tableView
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(myBucketListTableView)
    }
    
    override func configureView() {
        super.configureView()
        
        view.backgroundColor = .systemGray6
    }

    override func setConstraints() {
        super.setConstraints()
        
        myBucketListTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
    }
    
}

extension MyBucketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBucketListTableViewCell", for: indexPath) as! MyBucketListTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
    }
}
