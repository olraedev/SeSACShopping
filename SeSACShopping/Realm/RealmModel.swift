//
//  RealmModel.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/24/24.
//

import UIKit
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String?
    @Persisted var profileImage: String?
    
    @Persisted var searchList: List<SearchList>
    @Persisted var likeList: List<LikeList>
    
    convenience init(nickname: String?, profileImage: String?) {
        self.init()
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

class SearchList: Object {
    @Persisted(primaryKey: true) var name: String
    
    @Persisted(originProperty: "searchList") var user: LinkingObjects<User>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

class LikeList: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var link : String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    @Persisted var like: Bool
    
    @Persisted(originProperty: "likeList") var user: LinkingObjects<User>
    
    convenience init(productId: String, title: String, link: String, image: String, lprice: String, mallName: String, like: Bool) {
        self.init()
        self.productId = productId
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.like = true
    }
}
