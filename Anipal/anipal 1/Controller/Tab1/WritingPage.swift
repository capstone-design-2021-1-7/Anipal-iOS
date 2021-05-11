//
//  WritingPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

class WritingPage: UIViewController, sendBackDelegate {
    
    // 임시 데이터
    let initAnimals: [Animal] = [
        Animal(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
        Animal(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
        Animal(nameInit: "panda", image: #imageLiteral(resourceName: "panda"))
    ]
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var animalBtn: UIButton!
    
    var nameVar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imgButton.layer.borderWidth = 1
//        imgButton.layer.masksToBounds = false
//        imgButton.layer.borderColor = UIColor.gray.cgColor
//        imgButton.layer.cornerRadius = imgButton.frame.height/2
//        imgButton.clipsToBounds = true
        
        placeholderSetting()
        topView.layer.backgroundColor = UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1).cgColor
        view.layer.backgroundColor = UIColor(red: 0.95, green: 0.973, blue: 1, alpha: 1).cgColor
        textView.layer.cornerRadius = 10
        
        animalBtn.backgroundColor = .white
        animalBtn.layer.cornerRadius = animalBtn.frame.height/2
        animalBtn.layer.borderWidth = 0.3
        animalBtn.layer.borderColor = UIColor.lightGray.cgColor
        animalBtn.clipsToBounds = true
        
        // 네비게이션 바 색상
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.95, green: 0.973, blue: 1, alpha: 1)
        // 네비게이션 버튼 색상
        navigationController?.navigationBar.tintColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        // 네이베이션바 선 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
        
    func dataReceived(data: Int) {
        animalBtn.setImage(initAnimals[data].img, for: .normal)
    }
    
    @IBAction func clickAnimalBtn(_ sender: UIButton) {
        let sub = UIStoryboard(name: "SignUp", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "selectAnimalVC") as? SelectAnimal else {
            return
        }
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: UIButton) {
//        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SelectAnimal") else {
//            return
//        }
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
