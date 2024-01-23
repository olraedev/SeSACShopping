//
//  SystemFont.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

enum FontDesign: CGFloat {
    case smallest = 13
    case small
    case mid
    case big
    case biggest
    
    var light: UIFont {
        switch self {
        case .smallest: UIFont.systemFont(ofSize: FontDesign.smallest.rawValue)
        case .small: UIFont.systemFont(ofSize: FontDesign.small.rawValue)
        case .mid: UIFont.systemFont(ofSize: FontDesign.mid.rawValue)
        case .big: UIFont.systemFont(ofSize: FontDesign.big.rawValue)
        case .biggest: UIFont.systemFont(ofSize: FontDesign.biggest.rawValue)
        }
    }
    
    var bold: UIFont {
        switch self {
        case .smallest: UIFont.boldSystemFont(ofSize: FontDesign.smallest.rawValue)
        case .small: UIFont.boldSystemFont(ofSize: FontDesign.small.rawValue)
        case .mid: UIFont.boldSystemFont(ofSize: FontDesign.mid.rawValue)
        case .big: UIFont.boldSystemFont(ofSize: FontDesign.big.rawValue)
        case .biggest: UIFont.boldSystemFont(ofSize: FontDesign.biggest.rawValue)
        }
    }
}
