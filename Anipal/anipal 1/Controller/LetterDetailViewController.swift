//
//  LetterDetailViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class LetterDetailViewController: UIViewController {

    @IBOutlet weak var nameFrom: UILabel!
    @IBOutlet weak var textviewContent: UITextView!
    
    var nameFromVar: String?
    var contentVar: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        nameFrom.text = nameFromVar
        textviewContent.text = contentVar
    }
    
    @IBAction func wrtieBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WritingPage")as? WritingPage else {
            return
        }

        // name_to nil처리 수정필요 guard let?
        nextVC.nameVar = "RE: " + nameFromVar!

        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
