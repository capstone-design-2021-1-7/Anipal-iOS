//
//  ConceptTableViewCell.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/04.
//

import UIKit

class ConceptTableViewCell: UITableViewCell {

    @IBOutlet var conceptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
