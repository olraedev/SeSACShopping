//
//  RealmManager.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/25/24.
//

import UIKit
import RealmSwift

class RealmRepository {
    let realm = try! Realm()
    
    // Create
    func createUser() {
        let user = User(nickname: nil, profileImage: nil)
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            print("사용자 생성 오류")
        }
    }
    
    func appendSearchList(_ name: String) {
        var flag = true
        let user = readUser()
        
        user.searchList.forEach { value in
            if name == value.name {
                flag = false
            }
        }
        if flag == false { return }
        do {
            try realm.write {
                user.searchList.append(SearchList(name: name))
            }
        } catch {
            print("append searchList Error")
        }
    }
    
    func appendLikeList(_ item: NaverShoppingItem) {
        let user = readUser()
        do {
            try realm.write {
                user.likeList.append(LikeList(productId: item.productId, title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName, like: true))
            }
        } catch {
            print("append searchList Error")
        }
    }
    
    // Read
    func readAllUser() -> Results<User> {
        return realm.objects(User.self)
    }
    
    func readUser() -> User {
        return readAllUser().first!
    }
    
    // Update
    func updateUser(id: ObjectId, nickname: String?, profileImage: String) {
        do {
            try realm.write {
                realm.create(User.self, value: ["id": id, "nickname": nickname!, "profileImage": profileImage], update: .modified)
            }
        } catch {
            print("사용자 정보 업데이트 실패")
        }
    }
    
    func updateSearchList() {
        do {
            try realm.write {
                readUser().searchList.removeAll()
            }
        } catch {
            print("사용자 정보 업데이트 실패")
        }
    }
    
    // Delete
    func deleteUser() {
        let user = readUser()
        do {
            try realm.write {
                realm.delete(user)
            }
        } catch {
            print("사용자 삭제 실패")
        }
    }
}
