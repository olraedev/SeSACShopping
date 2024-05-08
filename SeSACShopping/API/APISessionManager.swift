//
//  APISessionManager.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/6/24.
//

import Foundation

class APISessionManager {
    static let shared = APISessionManager()
    static let baseURL = "https://openapi.naver.com/v1/search/shop.json"
    
    private init() { }
    
    func requestToNaverShoppingAsyncAwait(query: String, display: Int, start: Int, sort: String) async throws -> NaverShoppingInfo {
        let url = try APISessionManager.baseURL.asURL()
        var urlRequest: URLRequest
        let queryItems = [URLQueryItem(name: "query", value: query),
                                 URLQueryItem(name: "display", value: "\(display)"),
                                 URLQueryItem(name: "start", value: "\(start)"),
                                 URLQueryItem(name: "sort", value: sort)]
        let header = ["X-Naver-Client-Id": APIKey.NaverClientId,
                      "X-Naver-Client-Secret": APIKey.NaverClientSecret]
        
        urlRequest = try URLRequest(url: url.appending(queryItems: queryItems), method: .get)
        urlRequest.allHTTPHeaderFields = header
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, 
                response.statusCode == 200 else {
            throw NaverShoppingError.invalidResponse
        }
        
        guard let castData = try? JSONDecoder().decode(NaverShoppingInfo.self, from: data) else {
            throw NaverShoppingError.noData
        }
        
        return castData
    }
    
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
            DispatchQueue.main.async {
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
            }
        }.resume()
    }
}
