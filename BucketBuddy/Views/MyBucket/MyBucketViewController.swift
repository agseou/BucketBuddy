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
    
    enum Section: Int, CaseIterable {
        case profile
        case segment
        case myBuckets
    }
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(MyBucketListTableViewCell.self, forCellWithReuseIdentifier: "MyBucketListTableViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private let addBtn = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "새 버킷리스트 추가하기"
        config.cornerStyle = .capsule
        btn.configuration = config
        return btn
    }()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(collectionView)
        view.addSubview(addBtn)
    }
    
    override func configureView() {
        super.configureView()
        
        view.backgroundColor = .systemGray6
    }
    
    override func setConstraints() {
        super.setConstraints()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        addBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        addBtn.rx.tap
            .bind(with: self) { owner, _ in
                let vc = AddNewBucketViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension MyBucketViewController {
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
                    switch sectionKind {
                    case .profile:
                        return createProfileLayout()
                    case .segment:
                        return createSegmentLayout()
                    case .myBuckets:
                        return createBucketListLayout()
                    }
                }
    }
    
    func createProfileLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createSegmentLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createBucketListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension MyBucketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBucketListTableViewCell", for: indexPath) as! MyBucketListTableViewCell
        
        return cell
    }
    
}
