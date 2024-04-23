//
//  TabBarViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        
        let myBucketTab = UINavigationController(rootViewController: MyBucketViewController())
        let myBucketBarItem = UITabBarItem(title: "나의 버킷", image: UIImage(systemName: "heart"), tag: 0)
        myBucketTab.tabBarItem = myBucketBarItem
        
        let exploreTab = UINavigationController(rootViewController: ExploreViewController())
        let exploreBarItem = UITabBarItem(title: "탐색", image: UIImage(systemName: "heart"), tag: 1)
        exploreTab.tabBarItem = exploreBarItem
      
        self.viewControllers = [myBucketTab, exploreTab]
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
