//
//  ComingAnimalCell.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit

class ComingAnimalCell: UITableViewCell {
    
    @IBOutlet weak var animalSlider: CustomSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
