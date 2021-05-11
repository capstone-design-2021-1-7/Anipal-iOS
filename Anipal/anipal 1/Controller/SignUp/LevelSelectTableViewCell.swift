//
//  LevelSelectTableViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/04.
//

import UIKit

class LevelSelectTableViewCell: UITableViewCell {

    @IBOutlet var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        selectedBackgroundView = view
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
