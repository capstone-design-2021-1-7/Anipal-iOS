//
//  FavoriteViewController.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/05.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favLabelTitle: UILabel!
    
    override func viewDidLoad() {
        favLabelTitle.text = "Choose your favorites.".localized
        super.viewDidLoad()
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
//        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FavoriteVC") else {
//            return
//        }
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
