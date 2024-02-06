//
//  ResultManager.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit
import Alamofire

struct APIManager {
    func requestNaverShopping(query: String, display: Int, start: Int, sort: String, completionHandler: @escaping (NaverShoppingInfo) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)&start=\(start)&sort=\(sort)"
        let parameters: Parameters = ["":""]
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NaverClientId, "X-Naver-Client-Secret": APIKey.NaverClientSecret]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: NaverShoppingInfo.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
