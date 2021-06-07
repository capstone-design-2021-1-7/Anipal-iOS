//
//  AnimalDetail.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/12.
//

import UIKit

class AnimalDetail: UIViewController {

    var time = ""
    var name = ""
    var story = ""
    var img: UIImage?
    @IBOutlet var innerView: UIView!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var animalImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var storyView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 5
        innerView.layer.cornerRadius = 20
        animalImg.image = img
        timeLbl.text = time
        nameLbl.text = name.localized
        makeAnimalStory()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func clickOkBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAnimalStory() {
        switch name {
        case "cat":
            storyView.text = "CATSTORY".localized
        case "dog":
            storyView.text = "DOGSTORY".localized
        case "penguin":
            storyView.text = "PENGUINSTORY".localized
        case "turtle":
            storyView.text = "TURTLESTORY".localized
        case "rabbit":
            storyView.text = "RABBITSTORY".localized
        default:
            storyView.text = ""
        }
    }
    
}
