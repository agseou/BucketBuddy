//
//  AddNewBucketViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddNewBucketViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case title, memo, tag, date, datePicker, submit
    }
    
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, UUID>!
    private var isDatePickerVisible = false
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(collectionView)
    }
    
    override func configureView() {
        super.configureView()
        
        configureDataSource()
        updateSnapshot()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections(Section.allCases)
        for section in Section.allCases {
                switch section {
                case .datePicker:
                    // isDatePickerVisible이 true일 때만 datePicker 섹션에 아이템 추가
                    if isDatePickerVisible {
                        snapshot.appendItems([UUID()], toSection: .datePicker)
                    }
                default:
                    snapshot.appendItems([UUID()], toSection: section)
                }
            }
        dataSource.apply(snapshot)
    }
    
    
    private func configureDataSource() {
        
        let titleCellRegisteration = TitleCellRegisteration()
        let submitBtnCellRegisteration = SubmitBtnCellRegisteration()
        let memoCellRegisteration = MemoCellRegisteration()
        let tagCellRegistration = TagCellRegisteration()
        let dateCellRegistration = DateCellRegisteration()
        let datePickerCellRegistration = DatePickerCellRegisteration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .title:
                let cell = collectionView.dequeueConfiguredReusableCell(using: titleCellRegisteration, for: indexPath, item: itemIdentifier)
                
                return cell
            case .memo:
                let cell = collectionView.dequeueConfiguredReusableCell(using: memoCellRegisteration, for: indexPath, item: itemIdentifier)
                
                return cell
            case .tag:
                let cell = collectionView.dequeueConfiguredReusableCell(using: tagCellRegistration, for: indexPath, item: itemIdentifier)
                
                return cell
            case .date:
                let cell = collectionView.dequeueConfiguredReusableCell(using: dateCellRegistration, for: indexPath, item: itemIdentifier)
                
                
                return cell
            case .datePicker:
                if self.isDatePickerVisible == true {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: datePickerCellRegistration, for: indexPath, item: itemIdentifier)
                    
                    return cell
                } else {
                    return nil
                }
                
            case .submit:
                let cell = collectionView.dequeueConfiguredReusableCell(using: submitBtnCellRegisteration, for: indexPath, item: itemIdentifier)
                
                return cell
            }
        })
    }
}


extension AddNewBucketViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIdx, environment in
            
            let height: CGFloat
            switch sectionIdx {
            case Section.title.rawValue:
                height = 80 // 제목 섹션의 높이
            case Section.memo.rawValue:
                height = 120 // 메모 섹션의 높이
            case Section.tag.rawValue:
                height = 150 // 태그 섹션의 높이
            case Section.date.rawValue:
                height = 50 // 날짜 및 날짜 선택기 섹션의 높이
            case Section.datePicker.rawValue:
                height = self.isDatePickerVisible ? 350 : 0
            case Section.submit.rawValue:
                height = 70 // 제출 버튼 섹션의 높이
            default:
                height = 60 // 기본 섹션 높이
            }
            
            // Cell
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5 // 섹션 간 간격
            
            return layoutSection
        }
        return layout
    }
    
    
    
    private func TitleCellRegisteration() -> UICollectionView.CellRegistration<TitleCollectionViewCell, UUID> {
        
        UICollectionView.CellRegistration<TitleCollectionViewCell, UUID> { cell, indexPath, itemIdentifier in
           
        }
    }
    
    private func MemoCellRegisteration() -> UICollectionView.CellRegistration<MemoCollectionViewCell, UUID> {
        
        UICollectionView.CellRegistration<MemoCollectionViewCell, UUID> { cell, indexPath, itemIdentifier in
            
        }
    }
    
    private func SubmitBtnCellRegisteration() -> UICollectionView.CellRegistration<SubmitBtnCollectionViewCell, UUID> {
        
        UICollectionView.CellRegistration<SubmitBtnCollectionViewCell, UUID> { cell, indexPath, itemIdentifier in
            
        }
    }
    
    private func TagCellRegisteration() -> UICollectionView.CellRegistration<AddTagCollectionViewCell, UUID> {
        
        UICollectionView.CellRegistration<AddTagCollectionViewCell, UUID> { cell, indexPath, itemIdentifier in
            
        }
    }
    
    private func DateCellRegisteration() -> UICollectionView.CellRegistration<DateCollectionViewCell, UUID> {
        
        UICollectionView.CellRegistration<DateCollectionViewCell, UUID> { cell, indexPath, itemIdentifier in
            cell.toggle.isOn = self.isDatePickerVisible
            cell.toggle.addTarget(self, action: #selector(self.toggleChanged), for: .valueChanged)
        }
        
    }
    
    private func DatePickerCellRegisteration() -> UICollectionView.CellRegistration<DatePickerCollectionViewCell, UUID> {
        
        UICollectionView.CellRegistration<DatePickerCollectionViewCell, UUID> { cell, indexPath, itemIdentifier in
           
        }
    }
    
    @objc func toggleChanged(_ sender: UISwitch) {
        isDatePickerVisible = sender.isOn
        updateSnapshot()
    }
}

