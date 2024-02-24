//
//  UIViewControllerExtension.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

extension UIView: ConfigIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func setBackgroundColor() {
        self.backgroundColor = ColorDesign.bgc.fill
    }
}

extension UIViewController: ConfigIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
    
    func setBackgroundColor() {
        view.backgroundColor = ColorDesign.bgc.fill
    }
    
    func replaceTitle(_ title: String) -> String {
        var text: String = title.replacingOccurrences(of: "<b>", with: "")
        text = text.replacingOccurrences(of:"</b>", with: "")
        
        return text
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    
    func presentAlert(title: String, message: String, button: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: button, style: .default) { _ in
            completionHandler()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(button)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    
    func goToMainTabBarView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let tabBarController = UITabBarController()
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        
        searchViewController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        settingViewController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 1)
        
        tabBarController.tabBar.tintColor = ColorDesign.point.fill
        tabBarController.tabBar.backgroundColor = .clear
        tabBarController.setViewControllers([searchViewController, settingViewController], animated: true)
        
        sceneDelegate?.window?.rootViewController = tabBarController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension UICollectionViewCell {
    func replaceTitle(_ title: String) -> String {
        var text: String = title.replacingOccurrences(of: "<b>", with: "")
        text = text.replacingOccurrences(of:"</b>", with: "")
        
        return text
    }
}
