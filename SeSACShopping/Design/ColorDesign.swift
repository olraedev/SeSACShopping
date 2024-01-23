//
//  SystemColor.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

enum ColorDesign {
    case point
    case bgc
    case text
    case error
    case clear
    
    var fill: UIColor {
        switch self {
        case .point: UIColor(red: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        case .bgc: UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .text: UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .error: UIColor.red
        case .clear: UIColor.clear
        }
    }
}
