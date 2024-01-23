//
//  NicknameState.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

enum NicknameState {
    case length
    case special
    case number
    case available
    
    var text: String {
        switch self {
        case .length: "2글자 이상 10글자 미만으로 설정해주세요"
        case .special: "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .number: "닉네임에 숫자는 포함할 수 없어요"
        case .available: "사용 가능한 닉네임입니다."
        }
    }
    
    var color: UIColor {
        switch self {
        case .length, .special, .number: ColorDesign.error.fill
        case .available: ColorDesign.point.fill
        }
    }
}
