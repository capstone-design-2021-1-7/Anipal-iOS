//
//  BlockSettingVC.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/31.
//

import UIKit

class BlockSettingVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blockTableView: UITableView!
    
    var blockedUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockTableView.delegate = self
        blockTableView.dataSource = self
        titleLabel.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        titleLabel.text = "Block List".localized
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BlockSettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockSettingViewCell", for: indexPath) as! BlockSettingViewCell
        
        // 대표동물 이미지
        cell.thumbImg.backgroundColor = .white
        cell.thumbImg.layer.cornerRadius = cell.thumbImg.frame.height/2
        cell.thumbImg.image = blockedUsers[indexPath.row].thumbnail
        
        cell.userName.text = blockedUsers[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
                let deleteURL = "/users/ban/" + (ad?.blockUsers[indexPath.row])!
                del(url: deleteURL, token: session.value, completionHandler: { data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse {
                        if httpStatus.statusCode == 200 {
                            
                        } else {
                            print("error: \(httpStatus.statusCode)")
                        }
                    }
                })
            }
            ad?.blockUsers.remove(at: indexPath.row)
            blockedUsers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
