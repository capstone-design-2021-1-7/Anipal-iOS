//
//  StringExtension.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/01.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
