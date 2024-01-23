//
//  Sort.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit

enum Sort: String, CaseIterable {
    case sim
    case date
    case dsc
    case asc
    
    var title: String {
        switch self {
        case .sim: "정확도"
        case .date: "날짜순"
        case .dsc: "가격높은순"
        case .asc: "가격낮은순"
        }
    }
}
