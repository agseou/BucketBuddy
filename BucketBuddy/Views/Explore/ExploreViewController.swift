//
//  ExploreViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ExploreViewController: BaseViewController {
    
    private let segmentControl: UISegmentedControl = {
        let items = ["Bucket", "CompleteBucket"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0 // 기본 선택 인덱스 설정
        return control
    }()
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(BucketListTableViewCell.self, forCellReuseIdentifier: "BucketListTableViewCell")
        view.rowHeight = 100
        return view
    }()
    
    private let fetchTrigger = PublishSubject<Void>()
    private let fetchViewModel = FetchExploreViewModel()
    private let disposeBag = DisposeBag()
    var postList: [PostModel] = [] {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentValueChanged() {
        fetchData() // Segment 변경 시 데이터 다시 가져오기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTrigger.onNext(())
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        let fetchListInput = FetchExploreViewModel.Input(fetchTrigger: fetchTrigger.asObservable())
        let bucketListOutput = fetchViewModel.transform(input: fetchListInput)
        
        bucketListOutput.postResult
            .drive(with: self) { owner, fetchPostModel in
                dump(fetchPostModel)
                owner.postList = fetchPostModel.data
            }
            .disposed(by: disposeBag)
        
        fetchTrigger.onNext(())
        
    }
    
    private func fetchData() {
        print("========fetchData==========")
        fetchTrigger.onNext(())
    }
    
    
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListTableViewCell", for: indexPath) as! BucketListTableViewCell
        let item = postList[indexPath.row]
        cell.configureCell(title: item.title ?? "none", deadline: item.content2 ?? "없음", postID: item.post_id, productID: item.product_id!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let item = postList[indexPath.row]
            let detailVC = DetailPostViewController()
            detailVC.postID = item.post_id
            navigationController?.pushViewController(detailVC, animated: true)
        }
    
}
