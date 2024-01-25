//
//  UIViewControllerExtension.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

extension UIViewController: ConfigIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ConfigIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ConfigIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    func setBackgroundColor() {
        view.backgroundColor = ColorDesign.bgc.fill
    }
    
    func designPointColorButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = FontDesign.big.bold
        button.tintColor = ColorDesign.text.fill
        button.backgroundColor = ColorDesign.point.fill
        button.layer.cornerRadius = 8
    }
    
    func designCircleImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    func designPointBorderImageView(_ imageView: UIImageView) {
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = ColorDesign.point.fill.cgColor
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
        let button = UIAlertAction(title: button, style: .default) { action in
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

extension UITableViewCell {
    func designCircleImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    func designPointBorderImageView(_ imageView: UIImageView) {
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = ColorDesign.point.fill.cgColor
    }
}
