//
//  ProfileImages.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

struct Profile {
    static let images: [String] = ["profile1", "profile2", "profile3", "profile4", "profile5", "profile6", "profile7", "profile8", "profile9", "profile10", "profile11", "profile12", "profile13", "profile14"]
    
    var returnRandomImage: String {
        return Profile.images.shuffled()[0]
    }
}
