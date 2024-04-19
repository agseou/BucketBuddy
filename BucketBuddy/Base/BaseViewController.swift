//
//  BaseViewController.swift
//  BucketBuddy
//
//  Created by 은서우 on 4/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol BaseViewProtocol {
    func setupDelegate() // - 델리게이트
    func configureHierarchy() // - 계층
    func configureView() // - 프로퍼티 ex) label
    func setConstraints() // - 레이아웃
}

class BaseViewController: UIViewController, BaseViewProtocol {
    
    init() { // 코드로 UI를 구성하는 경우, 명시적으로 nib 파일을 사용하지 않겠다는 것을 표현
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDelegate()
        setupBind()
        configureHierarchy()
        configureView()
        setConstraints()
    }
    
    func setupDelegate() { }
    func setupBind() { }
    func configureHierarchy() { }
    func configureView() { }
    func setConstraints() { }
    
    //@available (*, unavailable)
    /// 모든 플랫폼과 모든 버전에서 해당 기능이 사용 불가능함을 표현
    /// 이를 통해 의도적으로 특정 메서드나 생성자를 사용할 수 없도록 막을 수 있다.
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
