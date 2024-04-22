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
  
    
    // MARK: - Components
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(MyProfileView.self, forCellWithReuseIdentifier: "profileImageView")
        view.register(SegmentControlCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SegmentControlCollectionReusableView")
        view.register(MyBucketListTableViewCell.self, forCellWithReuseIdentifier: "MyBucketListTableViewCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
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
    
    // MARK: - Properties
    enum Section: Int, CaseIterable {
        case profile
        case myBuckets // header에 segment를 pinned
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Function
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(collectionView)
        view.addSubview(addBtn)
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

// MARK: - CollectionView Layout
extension MyBucketViewController {
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            switch sectionKind {
            case .profile:
                return createProfileLayout()
            case .myBuckets:
                return createBucketListLayout()
            }
        }
    }
    
    func createProfileLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createBucketListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        // 헤더 사이즈와 설정
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

// MARK: - CollectionView Delegate & DataSource
extension MyBucketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .profile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileImageView", for: indexPath) as! MyProfileView
            // 프로필 셀 구성
            return cell
            
        case .myBuckets:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBucketListTableViewCell", for: indexPath) as! MyBucketListTableViewCell
            // 버킷리스트 셀 구성
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SegmentControlCollectionReusableView", for: indexPath) as! SegmentControlCollectionReusableView
        
        return header
    }
    
}
