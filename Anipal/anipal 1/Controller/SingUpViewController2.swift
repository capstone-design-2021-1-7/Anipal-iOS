//
//  SingUpViewController2.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class SingUpViewController2: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let languageList = ["English", "한국어", "日本語", "中文", "Italiano"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageTableView.delegate = self
        languageTableView.dataSource = self
        // titleLabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
        titleLabel.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "conceptSelectVC") else {
            return
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension SingUpViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as? LanguageTableViewCell else {
            return UITableViewCell()
        }
        cell.languageName.text = languageList[indexPath.row]
        cell.languageName.textColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        // cell.languageName.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        cell.checkBox.layer.borderWidth = 2
        cell.checkBox.layer.borderColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1).cgColor
        cell.checkBox.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "levelSelectVC") else {
            return
        }
        self.present(nextVC, animated: true, completion: nil)
    }
}
