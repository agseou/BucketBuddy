//
//  SettingViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift

class SettingViewController: BaseViewController {
    
    enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    
    var list = ["프로필 수정", "회원탈퇴"]
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension SettingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if item == "프로필 수정" {
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if item == "회원탈퇴" {
            showAlert(title: "회원탈퇴", message: "탈퇴버튼 선택 시, 계정은 삭제되며 복구되지 않습니다.") {
                UserNetworkManager.withDraw()
                    .subscribe(with: self) { owner, _ in
                        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
                        let vc = UINavigationController(rootViewController: LoginViewController())
                        sceneDelegate.window?.rootViewController = vc
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                    .disposed(by: self.disposeBag)
            }
        }
    }
}

extension SettingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
