//
//  MainPage2.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/26.
//

import UIKit

class MainPage2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - 네비게이션바 숨김
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - 동물모양 클릭시
    @IBAction func animalClick1(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "newletterVC") as? NewLetterViewController else {
            return
        }
        
        nextVC.contentVar = newLetters[0].contentInit
        nextVC.nameFromVar = newLetters[0].fromLetter
        
        // nextVC.modalTransitionStyle = .coverVertical
        // nextVC.modalPresentationStyle = .formSheet
        // navigationController?.modalPresentationStyle = .overCurrentContext
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func animalClick2(_ sender: UIButton) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "newletterVC") as? NewLetterViewController else {
            return
        }
        
        nextVC.contentVar = newLetters[1].contentInit
        nextVC.nameFromVar = newLetters[1].fromLetter
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .formSheet
        self.present(nextVC, animated: true)
        
    }
    
    @IBAction func animalClick3(_ sender: UIButton) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "newletterVC") as? NewLetterViewController else {
            return
        }
        
        nextVC.contentVar = newLetters[2].contentInit
        nextVC.nameFromVar = newLetters[2].fromLetter
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .formSheet
        self.present(nextVC, animated: true)
        
    }
    
}
