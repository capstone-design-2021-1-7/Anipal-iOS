//
//  LanguageLevelSelect.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/04.
//

import UIKit

protocol languageLevelDelegate {
    func level(data: Int)
}

class LanguageLevelSelect: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var languageName: UILabel!
    
    var langName = ""
    let levelList = ["초급", "중급", "고급"]
   
    var delegate: languageLevelDelegate?
    @IBOutlet var levelTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        levelTable.delegate = self
        levelTable.dataSource = self
        languageName.text = langName
    }

}

extension LanguageLevelSelect: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "levelSelectCell", for: indexPath) as? LevelSelectTableViewCell else {
            return UITableViewCell()
        }
        
        cell.levelLabel.text = levelList[indexPath.row]
        cell.levelLabel.layer.masksToBounds = true
        cell.levelLabel.layer.cornerRadius = 10
        // cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate?.level(data: indexPath.row)
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
}
