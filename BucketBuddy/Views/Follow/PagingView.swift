//
//  PagingView.swift
//  BucketBuddy
//
//  Created by eunseou on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PagingView: BaseView {
    
    private let categoryTitleList: [String]
    
    private let pagingTabBar: PagingTabBar
    
    private var followerList: [UserModel] = []
    private var follwingList: [UserModel] = []
    private let disposeBag = DisposeBag()
    private let fetchFollowerViewModel = FetchFollowerViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PagingCollectionViewCell.self, forCellWithReuseIdentifier: PagingCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    init(categoryTitleList: [String], pagingTabBar: PagingTabBar) {
        self.categoryTitleList = categoryTitleList
        self.pagingTabBar = pagingTabBar
        super.init(frame: .zero)
        pagingTabBar.delegate = self
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBind() {
        super.setBind()
        let fetchTrigger = PublishSubject<Void>()
        let input = FetchFollowerViewModel.Input(fetchTrigger: fetchTrigger)
        let output = fetchFollowerViewModel.transform(input: input)
        
        output.followers
            .drive(with: self) { owner, result in
                owner.followerList = result
            }
            .disposed(by: disposeBag)
        
        output.followings
            .drive(with: self) { owner, result in
                owner.follwingList = result
            }
            .disposed(by: disposeBag)
    }
    
}

extension PagingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewFrame = collectionView.frame
        return CGSize(width: collectionViewFrame.width, height: collectionViewFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let indexPath = IndexPath(row: Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width), section: 0)
        pagingTabBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension PagingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagingCollectionViewCell.identifier, for: indexPath) as? PagingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.followerList = self.followerList
        cell.follwingList = self.follwingList
        
        return cell
    }
}

extension PagingView: PagingDelegate {
    func didTapPagingTabBarCell(scrollTo indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
