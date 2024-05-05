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
        view.isUserInteractionEnabled = true
        return view
    }()
    private let addBtn = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "새 버킷리스트 추가하기"
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .customBlue
        btn.configuration = config
        return btn
    }()
    
    // MARK: - Properties
    enum Section: Int, CaseIterable {
        case profile
        case myBuckets // header에 segment를 pinned
    }
    
    private let fetchTrigger = PublishSubject<Void>()
    
    private let viewModel = CompleteToggleViewModel()
    private let fetchMyBucketViewModel = FetchMyBucketListViewModel()
    private let fetchMyProfileViewModel = FetchMyProfileViewModel()
    private var nickname: String = DefaultUDManager.shared.nickname
    private var followCnt: (Int, Int) = (0, 0)
    private let disposeBag = DisposeBag()
    var postList: [PostModel] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        fetchTrigger.onNext(())
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(collectionView)
        view.addSubview(addBtn)
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapSettingsButton))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func didTapSettingsButton() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        
        let fetchBucketListInput = FetchMyBucketListViewModel.Input(fetchTrigger: fetchTrigger.asObservable())
        let bucketListOutput = fetchMyBucketViewModel.transform(input: fetchBucketListInput)
        
        bucketListOutput.postResult
            .drive(with: self) { owner, fetchPostModel in
                dump(fetchPostModel)
                owner.postList = fetchPostModel.data
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        let fetchMyProfileInput = FetchMyProfileViewModel.Input(fetchTrigger: fetchTrigger)
        let fetchMyProfileOutput = fetchMyProfileViewModel.transform(input: fetchMyProfileInput)
        
        fetchMyProfileOutput.profileResult
            .drive(with: self) { owner, profile in
                DefaultUDManager.shared.nickname = profile.nick
                DefaultUDManager.shared.email = profile.email
                owner.nickname = profile.nick
                owner.followCnt = (profile.followers.count, profile.following.count)
            }
            .disposed(by: disposeBag)
        
        fetchTrigger.onNext(())
        
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
        return section == 0 ? 1 : postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .profile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileImageView", for: indexPath) as! MyProfileView
            
            cell.configureCell(nickname: nickname, followerCnt: followCnt.0, followingCnt: followCnt.1)
            Observable.merge( cell.followerBtn.rx.tap.asObservable(), cell.followingBtn.rx.tap.asObservable())
                .subscribe(with: self) { owner, _ in
                    let vc = FollowViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: cell.disposeBag)
            
            return cell

        case .myBuckets:
            let item = postList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBucketListTableViewCell", for: indexPath) as! MyBucketListTableViewCell
            cell.configureCell(title: item.title ?? "none", deadline: item.content2 ?? "없음", postID: item.post_id, productID: item.product_id!)
            cell.onCompleteTapped = { [weak self] productID, postID in
                print("tap")
                self?.toggleCompletionStatus(productID: productID, postID: postID)
            }
            cell.onEditTapped = { [weak self] postID in
                self?.editPost(postID: postID)
            }
            cell.onDeleteTapped = { [weak self] postID in
                
                self?.deletePost(postID: postID)
            }
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
    
    private func toggleCompletionStatus(productID: String, postID: String) {
        let input = CompleteToggleViewModel.Input(trigger: Observable.just((productID, postID)))
        let output = viewModel.transform(input: input)
        
        output.successSignal
            .drive(with: self) { owner,_ in
                owner.fetchData()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func editPost(postID: String) {
        let vc = AddNewBucketViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func deletePost(postID: String) {
        PostNetworkManager.deletePost(postID: postID)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success():
                    owner.fetchData()
                case .unauthorized:
                    print("유효하지 않은 액세스 토큰")
                case .forbidden:
                    print("접근권한 없음")
                case .nonePost:
                    print("이미 삭제된 포스트 입니다.")
                case .expiredAccessToken:
                    print("에러 발생: 엑세스 토큰 만료")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: self.disposeBag)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader else {
//            return UICollectionReusableView()
//        }
//        
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SegmentControlCollectionReusableView", for: indexPath) as! SegmentControlCollectionReusableView
//        
//        return header
//    }
    
    private func fetchData() {
        print("========fetchData==========")
        fetchTrigger.onNext(())
    }
    
}
