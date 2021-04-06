//
//  WritingPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

class WritingPage: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var nameVar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameVar
        placeholderSetting()
        
    }

    @IBAction func send(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SelectAnimal") else {
            return
        }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - 편지내용 Place Holder 작업
extension WritingPage: UITextViewDelegate {

    func placeholderSetting() {
        textView.delegate = self
        textView.text = "Enter the content"
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "Enter the content"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }

        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
