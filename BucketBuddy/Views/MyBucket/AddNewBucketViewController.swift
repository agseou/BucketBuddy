//
//  AddNewBucketViewController.swift
//  BucketBuddy
//
//  Created by eunseou on 4/20/24.
//

import UIKit
import RxSwift

final class AddNewBucketViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleTextField =  {
        let view = UITextField()
        view.placeholder = "title"
        view.borderStyle = .roundedRect
        return view
    }()
    private lazy var memoTextField =  {
        let view = UITextView()
        view.delegate = self
        view.textColor = .gray
        view.text = "메모를 입력해주세요"
        return view
    }()
    private let submitBtn = RegularButton(text: "완료")
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        // 스크롤 뷰와 콘텐츠 뷰 설정
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(memoTextField)
        contentView.addSubview(submitBtn)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(800)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        memoTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        submitBtn.snp.makeConstraints {
            $0.top.equalTo(memoTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
}

// MARK: - UITextViewDelegate 
extension AddNewBucketViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
}
