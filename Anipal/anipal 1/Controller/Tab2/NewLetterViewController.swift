//
//  NewLetterViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/03/02.
//

import UIKit

class NewLetterViewController: UIViewController {

    @IBOutlet var nameFrom: UILabel!
    @IBOutlet var contentLabel: UILabel!

    var nameFromVar: String?
    var contentVar: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        contentLabel.sizeToFit()
        nameFrom.text = nameFromVar
        contentLabel.text = contentVar
        // Do any additional setup after loading the view.
    }

    // MARK: - 네비게이션바 숨기기
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
//    }

    // MARK: - 버리기 버튼 클릭시
    @IBAction func clickDismiss(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }

    // MARK: - 답장 버튼 클릭시
    @IBAction func clickReply(_ sender: UIButton) {
        let sub = UIStoryboard(name: "Tab1", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "WritingPage") as? WritingPage else {
            return
        }
//
//        guard let prevVC = self.presentingViewController else {
//            return
//        }

        nextVC.nameVar = "RE: " + nameFromVar!

//        self.presentingViewController?.dismiss(animated: true) {
//            prevVC.navigationController?.pushViewController(nextVC, animated: true)
//        }

        self.navigationController?.pushViewController(nextVC, animated: true)
        // nextVC.modalPresentationStyle = .fullScreen
        // self.present(nextVC, animated: true)
    }

}
