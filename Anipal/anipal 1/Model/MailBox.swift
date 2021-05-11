//
//  MailBox.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/16.
//

import UIKit

struct MailBox {
    let mailBoxID: String
    let isOpened: Bool
    let partner: [String: Any]
    let thumbnail: [String: String]
    let arrivalDate: String
    let letterCount: Int
    
    init(mailBoxID: String, isOpened: Bool, partner: [String: Any], thumbnail: [String: String], arrivalDate: String, letterCount: Int) {
        self.mailBoxID = mailBoxID
        self.isOpened = isOpened
        self.partner = partner
        self.thumbnail = thumbnail
        self.arrivalDate = arrivalDate
        self.letterCount = letterCount
    }
}
