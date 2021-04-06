//
//  languageTableViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/04.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet var checkBox: UIButton!
    @IBOutlet var languageName: UILabel!
    @IBOutlet var languageLevel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
