//
//  UIViewControllerExtensions.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

@objc protocol DesignViews {
    func designViews()
    @objc optional func designNavigationItem()
}

protocol ConfigConstraints {
    func configConstraints()
}

protocol ConfigIdentifier {
    static var identifier: String { get }
}

protocol ConfigStoryBoardIdentifier {
    static var sbIdentifier: String { get }
}

@objc protocol ConfigButtonClicked {
    @objc optional func leftBarButtonClicked()
}

@objc protocol MyDefinedFunctions {
    
}
