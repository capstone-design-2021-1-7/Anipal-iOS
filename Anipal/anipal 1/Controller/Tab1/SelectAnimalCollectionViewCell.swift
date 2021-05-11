//
//  SelectAnimalCollectionViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

class SelectAnimalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .blue
            } else {
                backgroundColor = .gray
            }
        }
    }
}
