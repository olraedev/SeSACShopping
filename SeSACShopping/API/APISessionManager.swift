//
//  APISessionManager.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/6/24.
//

import Foundation

class APISessionManager {
    static let shared = APISessionManager()
    
    private init() { }
    
    func requestToNaverShopping(query: String, display: Int, start: Int, sort: String, completionHandler: @escaping (NaverShoppingInfo?, NaverShoppingError?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "openapi.naver.com"
        components.path = "v1/search/shop.json"
        components.queryItems = [URLQueryItem(name: "query", value: query),
                                 URLQueryItem(name: "display", value: "\(display)"),
                                 URLQueryItem(name: "start", value: "\(start)"),
                                 URLQueryItem(name: "sort", value: sort)]
        
        guard let componentsURL = components.url else {
            return
        }
        
        var url = URLRequest(url: componentsURL)
        url.setValue(APIKey.NaverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        url.setValue(APIKey.NaverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completionHandler(nil, .failedRequest)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completionHandler(nil, .invalidResponse)
                return
            }
            
            if let data = data, let castData = try? JSONDecoder().decode(NaverShoppingInfo.self, from: data) {
                completionHandler(castData, nil)
                return
            }
            
            completionHandler(nil, .noData)
        }.resume()
    }
}
