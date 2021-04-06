//
//  userInfo.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/04.
//

import Foundation

struct User {
    var name: String
    let gender: String
    let age: UInt
    let birthday: String
    let email: String
    let provider: String
    var concept: String
    var favorites: [String]
    var languages: [String]
    
    init(name: String, gender: String, age: UInt, birthday: String, email: String, provider: String, concept: String, favorites: [String], languages: [String]) {
        self.name = name
        self.gender = gender
        self.age = age
        self.birthday = birthday
        self.email = email
        self.provider = provider
        self.concept = concept
        self.favorites = favorites
        self.languages = languages
    }
}

// Dummy data
 var users: [User] = [
    User(name: "bird", gender: "female", age: 18, birthday: "2021-04-04", email: "abc123@gmail.com", provider: "google", concept: "언어", favorites: ["여행"], languages: ["한국어", "영어"]),
    User(name: "monkey", gender: "male", age: 43, birthday: "2020-03-23", email: "asdfqwer@gmail.com", provider: "facebook", concept: "우정", favorites: ["영화", "요리"], languages: ["한국어"])
]
