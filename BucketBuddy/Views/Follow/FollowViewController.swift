//
//  FollowViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/28/24.
//

import UIKit
import SnapKit

class FollowViewController: BaseViewController {
    
    private let categoryTitleList = [ "팔로워", "팔로잉" ]
    
    private lazy var pagingTabBar = PagingTabBar(categoryTitleList: categoryTitleList)
    private lazy var pagingView = PagingView(categoryTitleList: categoryTitleList, pagingTabBar: pagingTabBar)
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        [  pagingTabBar,
           pagingView
        ].forEach { view.addSubview($0) }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        pagingTabBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(pagingTabBar.cellHeight)
        }
        pagingView.snp.makeConstraints {
            $0.top.equalTo(pagingTabBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
