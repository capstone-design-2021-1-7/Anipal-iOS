//
//  userInfo.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/04.
//

import UIKit

struct User {
    var name: String
    let gender: String
    let age: UInt
    let birthday: String
    let email: String
    var favorites: [String]
    var languages: [String]
    var thumbnail: UIImage
    
    init(name: String, gender: String, age: UInt, birthday: String, email: String, favorites: [String], languages: [String], thumbnail: UIImage) {
        self.name = name
        self.gender = gender
        self.age = age
        self.birthday = birthday
        self.email = email
        self.favorites = favorites
        self.languages = languages
        self.thumbnail = thumbnail
    }
}
