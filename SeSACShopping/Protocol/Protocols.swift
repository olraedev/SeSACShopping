//
//  UIViewControllerExtensions.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

@objc protocol DesignViews {
    func designOutlets()
    @objc optional func designNavigationItem()
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
