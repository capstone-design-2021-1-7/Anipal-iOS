//
//  letters.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

struct Letter {
    let senderID: String
    let name: String
    var language: [String]
    var favorites: [String]
    let animal: [String]
    let receiverID: String
    let content: String
    let arrivalDate: String
    let sendDate: String
    let animalImg: UIImage
 
    init(senderID: String, name: String, language: [String], favorites: [String], animal: [String], receiverID: String, content: String, arrivalDate: String, sendDate: String, animalImg: UIImage) {
        self.senderID = senderID
        self.name = name
        self.language = language
        self.favorites = favorites
        self.animal = animal
        self.receiverID = receiverID
        self.content = content
        self.arrivalDate = arrivalDate
        self.sendDate = sendDate
        self.animalImg = animalImg
    }
}
