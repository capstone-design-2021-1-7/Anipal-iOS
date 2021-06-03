//
//  MyAnimalPageCollectionViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/09.
//

import UIKit

class MyAnimalPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var animalImage: UIImageView!
    @IBOutlet var starImage: UIImageView!
    @IBOutlet var animalName: UILabel!
    @IBOutlet var delayTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        animalImage.layer.cornerRadius = 15
        animalName.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
                animalName.textColor = .white
            } else {
                backgroundColor = .white
                animalName.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
            }
        }
    }

}
