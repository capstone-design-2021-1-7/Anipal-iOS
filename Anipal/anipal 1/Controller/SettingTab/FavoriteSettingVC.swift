//
//  DefaultInfoVC.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/01.
//

import UIKit

class FavoriteSettingVC: UIViewController {
    
    @IBOutlet weak var favLabelTitle: UILabel!
    @IBOutlet var favCollectionView: FavoriteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favLabelTitle.text = "Choose your favorites.".localized
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ad?.favorites = favCollectionView.userFav
    }
}
