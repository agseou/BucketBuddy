//
//  UIViewController+Extension.swift
//  BucketBuddy
//
//  Created by eunseou on 4/17/24.
//

import UIKit
import RxSwift

extension UIViewController {
    
    // 키보드 숨기기
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Alert창
    func showAlert(title: String, message: String?, buttonTitle: String = "확인", completionHandler: @escaping (() -> Void) = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    
    func showReLoginAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let alert = UIAlertController(title: "재로그인 필요", message: "세션이 만료되었습니다. 다시 로그인해주세요.", preferredStyle: .alert)
        let reLoginAction = UIAlertAction(title: "재로그인", style: .default) { [weak self] _ in
            self?.switchToLoginViewController()
        }
        alert.addAction(reLoginAction)
        window.rootViewController?.present(alert, animated: true)
    }

    func switchToLoginViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let vc = LoginViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
}
