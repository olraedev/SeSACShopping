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
        return UIFont.systemFont(ofSize: self.rawValue)
    }
    
    var bold: UIFont {
        return UIFont.boldSystemFont(ofSize: self.rawValue)
    }
}
