//
//  NaverShoppingError.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/6/24.
//

import Foundation

enum NaverShoppingError: Error {
    case failedRequest
    case noData
    case invalidResponse
    
    var errorMessage: String {
        switch self {
        case .failedRequest: "요청에 실패하였습니다.\n잠시 후 다시 시도해주세요."
        case .noData: "요청 데이터를 받아오는데 실패하였습니다.\n잠시 후 다시 시도해주세요."
        case .invalidResponse: "서버가 응답하지 않습니다.\n잠시 후 다시 시도해주세요."
        }
    }
}
