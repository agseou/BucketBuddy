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

    private let segmentControl = {
        let segment = CapsuleSegmentedControl(items: ["미완료", "완료🏆"])
        return segment
    }()
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
        
        view.addSubview(segmentControl)
        view.addSubview(myBucketListTableView)
    }
    
    override func configureView() {
        super.configureView()
        
        view.backgroundColor = .systemGray6
    }

    override func setConstraints() {
        super.setConstraints()
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
        myBucketListTableView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
