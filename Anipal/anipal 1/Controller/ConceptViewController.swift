//
//  ConceptViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/04.
//

import UIKit

class ConceptViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var conceptTable: UITableView!
    
    let conceptList = ["우정", "사랑", "언어"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conceptTable.delegate = self
        conceptTable.dataSource = self
        //titleLabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
        titleLabel.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FavoriteVC") else {
            return
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
extension ConceptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conceptList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conceptSelectCell", for: indexPath) as? ConceptTableViewCell else {
            return UITableViewCell()
        }
        cell.conceptLabel.text = conceptList[indexPath.row]
        cell.conceptLabel.layer.masksToBounds = true
        cell.conceptLabel.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
