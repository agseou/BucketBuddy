//
//  UIViewController+Extension.swift
//  BucketBuddy
//
//  Created by eunseou on 4/17/24.
//

import UIKit

extension UIViewController {
    
    // 키보드 숨기기
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Alert창
    func showAlert(title: String, message: String?, buttonTitle: String = "확인") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // 로딩 인디케이터
    func showLoadingIndicator() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = self.view.center
        spinner.startAnimating()
        self.view.addSubview(spinner)
    }
    
    func hideLoadingIndicator() {
        self.view.subviews.filter { $0 is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
}
