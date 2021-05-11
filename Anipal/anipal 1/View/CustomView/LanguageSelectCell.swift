//
//  LanguageSelectCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/30.
//

import UIKit

class LanguageSelectCell: UITableViewCell {

    @IBOutlet var checkBox: UIImageView!
    @IBOutlet var languageName: UILabel!
    @IBOutlet var languageLevel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
