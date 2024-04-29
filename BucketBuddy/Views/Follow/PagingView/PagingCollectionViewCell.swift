//
//  PagingCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/28/24.
//

import UIKit
import SnapKit

class PagingCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PagingCollectionViewCell"
       
    private lazy var tableView = {
        let view = UITableView()
        view.register(FollowerListTableViewCell.self, forCellReuseIdentifier: "FollowerListTableViewCell")
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 50
        return view
    }()
    
    var followerList: [UserModel] = [] { didSet { tableView.reloadData() }}
    var follwingList: [UserModel] = [] { didSet { tableView.reloadData() }}
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [tableView].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension PagingCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerListTableViewCell", for: indexPath) as! FollowerListTableViewCell
        
        let item = indexPath.item
        cell.update(image: UIImage(resource: .monkey), nickname: followerList[item].nick)
        
        return cell
    }
}
