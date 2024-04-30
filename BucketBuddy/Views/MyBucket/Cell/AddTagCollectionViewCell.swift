//
//  AddTagCollectionViewCell.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import UIKit

class AddTagCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var tagCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return collectionView
    }()
    private let tagTextField =  {
        let view = UITextField()
        view.placeholder = "tag"
        view.borderStyle = .roundedRect
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(tagCollectionView)
        addSubview(tagTextField)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(50)
        }
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
    }

}

extension AddTagCollectionViewCell {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIdx, environment in
            
            let layoutSection: NSCollectionLayoutSection
            
            //cell
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            
            return layoutSection
        }
        return layout
    }
}
