//
//  UserDefaultsManager.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    enum key: String {
        case profile
        case nickname
        case searchList
        case likeList
    }
    
    func getStringValue(_ key: UserDefaultsManager.key) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    func setStringValue(_ key: UserDefaultsManager.key, value: String) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getSearchList() -> [String] {
        return UserDefaults.standard.stringArray(forKey: UserDefaultsManager.key.searchList.rawValue) ?? []
    }
    
    func setSearchList(value: [String]) {
        UserDefaults.standard.set(value, forKey: UserDefaultsManager.key.searchList.rawValue)
    }

    func getLikeList() -> [String] {
        return UserDefaults.standard.stringArray(forKey: UserDefaultsManager.key.likeList.rawValue) ?? []
    }
    
    func setLikeList(value: [String]) {
        UserDefaults.standard.set(value, forKey: UserDefaultsManager.key.likeList.rawValue)
    }
    
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.key.profile.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.key.nickname.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.key.searchList.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.key.likeList.rawValue)
    }
    
    private init() {}
}
