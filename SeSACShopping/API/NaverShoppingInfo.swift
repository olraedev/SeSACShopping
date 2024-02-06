//
//  NaverShoppingInfo.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/6/24.
//

import Foundation

struct NaverShoppingInfo: Decodable {
    let total: Int
    let start: Int
    let display: Int
    var items: [NaverShoppingItem]
}

struct NaverShoppingItem: Decodable {
    let title: String
    let link : String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
