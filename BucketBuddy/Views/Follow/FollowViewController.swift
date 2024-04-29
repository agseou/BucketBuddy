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
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
}

private extension FollowViewController {
    func setupLayout() {
        [
            pagingTabBar,
            pagingView
        ].forEach { view.addSubview($0) }
        
        pagingTabBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(pagingTabBar.cellHeight)
        }
        pagingView.snp.makeConstraints { make in
            make.top.equalTo(pagingTabBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
