//
//  DesignableSlider.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 13.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}
