//
//  DetailPostViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailPostViewController: BaseViewController {
    
    private lazy var commentTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(PostHeaderView.self, forCellReuseIdentifier: "PostHeaderView")
        return tableView
    }()
    private let inputContainerView = UIView()
    private let inputTextField = {
        let view = UITextField()
        view.placeholder = "댓글을 작성하세요"
        return view
    }()
    private let sendButton = {
        let btn = UIButton()
        btn.setTitle("입력", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    private let fetchTrigger = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    var commentList: [comment] = [] {
        didSet { commentTableView.reloadData()}
    }
    var titles: String?
    var date: String?
    var memo: String?
    var postID: String?
    private let writeCommentsViewModel = WriteCommentsViewModel()
    private let fetchPostIDViewModel = FetchPostIDViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTrigger.onNext(postID!)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(commentTableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(inputTextField)
        inputContainerView.addSubview(sendButton)
    }
    
    override func configureView() {
        super.configureView()
        
        inputContainerView.backgroundColor = .white
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        commentTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        inputContainerView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        inputTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(sendButton.snp.left).offset(-10)
        }
        
        sendButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        let fetchListInput = FetchPostIDViewModel.Input(fetchTrigger: fetchTrigger.asObservable())
        let bucketListOutput = fetchPostIDViewModel.transform(input: fetchListInput)
        
        bucketListOutput.postModel
            .drive(with: self) { owner, postModel in
                owner.commentList = postModel.comments
            }
            .disposed(by: disposeBag)
        
        print(commentList.count)
        
        fetchTrigger.onNext(postID!)
        
        let writeCommentInput = WriteCommentsViewModel.Input(
            tapSubmitBtn: sendButton.rx.tap.asObservable(),
            comment:inputTextField.rx.text.orEmpty.asObservable(),
            id: Observable.just(postID!))
        let CommentListOutput = writeCommentsViewModel.transform(input: writeCommentInput)
        
        CommentListOutput.successResult
            .drive(with: self) { owner, result in
                owner.inputTextField.text = ""
            }
            .disposed(by: disposeBag)
        fetchTrigger.onNext(postID!)
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        // 키보드 높이 계산
        let keyboardHeight = keyboardFrame.height
        
        // 탭바의 높이
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        
        // 입력창을 키보드 위로 올림 (탭바 높이와 안전 영역을 고려)
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.snp.remakeConstraints { make in
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(50)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - tabBarHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.snp.remakeConstraints { make in
                make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(50)
            }
            self.view.layoutIfNeeded()
        }
    }
    
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return commentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderView", for: indexPath) as! PostHeaderView
            
            cell.configure(with: titles!, memo: memo!, date: date!, imageUrl: "")
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
            let comment = commentList[indexPath.row]
            cell.configureCell(nickname: comment.creator.nick, comment: comment.content, date: comment.createdAt, profileImageURL: comment.creator.profileImage ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1 // 첫 번째 섹션에는 헤더가 필요 없으므로 최소화
        } else {
            return 10 // 댓글 섹션의 헤더 높이 설정
        }
    }
    
}
