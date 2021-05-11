//
//  RandomReceiveAnimal.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/27.
//

import Foundation

struct RandomAnimal {
    var id: String
    var animal: [String: String]
    
    init(id: String, animal: [String: String]) {
        self.id = id
        self.animal = animal
    }
}

struct RandomLetter {
    var id: String
    var content: String
    var sendTime: String
    var arriveTime: String
    var sender: [String: Any]
    var animal: [String: String]
    
    init(id: String, content: String, sendTime: String, arriveTime: String, sender: [String: Any], animal: [String: String]) {
        self.id = id
        self.content = content
        self.sendTime = sendTime
        self.arriveTime = arriveTime
        self.sender = sender
        self.animal = animal
    }
}
