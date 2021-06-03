//
//  AnimalCollectionViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/05.
//

import UIKit

class AnimalCollectionViewCell: UICollectionViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet weak var aniTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 15
        name.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
                name.textColor = .white
            } else {
                backgroundColor = .white
                name.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
            }
        }
    }

}
