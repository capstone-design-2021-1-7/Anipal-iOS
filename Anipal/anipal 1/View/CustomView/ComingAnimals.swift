//
//  ComingAnimals.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit

class ComingAnimals: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var handleImg: UIImageView!
    @IBOutlet weak var comingTableView: ComingAnimalTableView!
    
    override func viewDidLoad() {
        self.view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: comingTableView.tableView.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        comingTableView.loadComingAnimals()
    }
}
