//
//  AccessoryCollectionViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/12.
//

import UIKit

class AccessoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var accessoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {

                layer.borderColor = UIColor.gray.cgColor
                layer.borderWidth = 3

            } else {
                layer.borderWidth = 0
            }
        }
    }

}
