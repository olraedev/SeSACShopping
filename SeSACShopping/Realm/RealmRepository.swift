//
//  RealmManager.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/25/24.
//

import Foundation
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
        if let value = readForPrimaryKey(SearchList.self, name: name) {
            // 순서 바꿔야하는디
            deleteSearchList(value)
        }
        do {
            try realm.write {
                realm.add(SearchList(name: name))
            }
        } catch {
            print("append searchList Error")
        }
    }
    
    func appendLikeList(_ item: NaverShoppingItem) {
        do {
            try realm.write {
                realm.add(LikeList(productId: item.productId, title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName, like: true))
            }
        } catch {
            print("append searchList Error")
        }
    }
    
    // Read
    func readAll<T: Object>(_ type: T.Type) -> [T] {
        return Array(realm.objects(T.self))
    }
    
    func readUser() -> User {
        return readAll(User.self).first!
    }
    
    func readForPrimaryKey<T: Object>(_ type: T.Type, name: String) -> T? {
        realm.object(ofType: T.self, forPrimaryKey: name)
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
    
    func deleteAllSearchList() {
        do {
            try realm.write {
                realm.delete(readAll(SearchList.self))
            }
        } catch {
            print("사용자 정보 업데이트 실패")
        }
    }
    
    func deleteSearchList(_ object: ObjectBase) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("삭제 실패")
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
