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
}

extension UICollectionViewCell {
    func replaceTitle(_ title: String) -> String {
        var text: String = title.replacingOccurrences(of: "<b>", with: "")
        text = text.replacingOccurrences(of:"</b>", with: "")
        
        return text
    }
}
