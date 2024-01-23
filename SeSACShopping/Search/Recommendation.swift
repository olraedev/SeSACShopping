//
//  Recommend.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/23/24.
//

import UIKit

struct Recommendation {
    let list: [String] = ["숏패딩", "롱패딩", "수분크림", "크록스", "로션", "청바지", "백팩", "바디로션", "모니터", "키보드", "마우스"]
    
    var returnShuffledList: [String] {
        return list.shuffled()
    }
}
