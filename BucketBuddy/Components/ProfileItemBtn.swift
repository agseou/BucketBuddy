//
//  FollowingBtn.swift
//  BucketBuddy
//
//  Created by eunseou on 4/24/24.
//

import UIKit
import SnapKit

class ProfileItemBtn: UIButton {
    
    private let stackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        return view
    }()
    private let numberLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(number: Int, description: String) {
        super.init(frame: .zero)
        numberLabel.text = "\(number)"
        descriptionLabel.text = description
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        numberLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.font = .systemFont(ofSize: 14)
        
        stackView.isUserInteractionEnabled = false
        numberLabel.isUserInteractionEnabled = false
        descriptionLabel.isUserInteractionEnabled = false
        
        addSubview(stackView)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func update(number: Int, description: String) {
        numberLabel.text = String(number)
        descriptionLabel.text = description
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
