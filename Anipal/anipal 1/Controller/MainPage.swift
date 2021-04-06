//
//  MainPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

class MainPage: UIViewController {

    @IBOutlet weak var textBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBtn.layer.borderWidth = 2
        textBtn.layer.cornerRadius = 10
        textBtn.layer.borderColor = UIColor.gray.cgColor
        textBtn.setTitle("\(letters.count)건의 편지가 답장을 기다리고있어요!", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - 네비게이션바 숨김
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - 편지함 클릭시
    @IBAction func postBoxClick(_ sender: UIButton) {
        
    }
    
    // MARK: - 편지도착 텍스트 클릭시
    @IBAction func textBtnClick(_ sender: UIButton) {
//        guard let letterListVC = self.storyboard?.instantiateViewController(identifier: "LetterListVC") else {
//            return
//        }
//
//        self.navigationController?.pushViewController(letterListVC, animated: true)
        self.tabBarController?.selectedIndex = 2
    }
    
    // MARK: - 글쓰기버튼 클릭시
    @IBAction func writeButton(_ sender: UIButton) {
        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") else {
            return
        }

        self.navigationController?.pushViewController(writingVC, animated: true)
    }

}
