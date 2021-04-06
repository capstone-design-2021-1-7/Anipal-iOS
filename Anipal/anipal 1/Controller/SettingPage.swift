//
//  SettingPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SettingPage: UIViewController {
    
    let settings: [String] = ["User info".localized, "Language".localized, "Concept".localized, "Favorite".localized]
    
    let sections: [String] = ["User info".localized, "Language".localized, "Concept".localized, "Favorite".localized]

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.setTitle("Logout".localized, for: .normal)
        
        self.settingTableView.tableFooterView = UIView(frame: .zero)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickLogoutBtn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager.init().logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
}

extension SettingPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPageTableViewCell", for: indexPath) as? SettingPageTableViewCell else { return UITableViewCell() }
        cell.settingLabel.text = settings[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0: self.performSegue(withIdentifier: "DefaultInfoVC", sender: nil)
        case 1: guard let langSetVC = self.storyboard?.instantiateViewController(identifier: "LanguageSettingVC") as? LanguageSettingVC else { return }
            
            langSetVC.modalTransitionStyle = .coverVertical
            langSetVC.modalPresentationStyle = .formSheet
            
            self.present(langSetVC, animated: true, completion: nil)
        case 2: guard let langSetVC = self.storyboard?.instantiateViewController(identifier: "ConceptSettingVC") as? ConceptSettingVC else { return }
            
            langSetVC.modalTransitionStyle = .coverVertical
            langSetVC.modalPresentationStyle = .formSheet
            
            self.present(langSetVC, animated: true, completion: nil)
        case 3: guard let langSetVC = self.storyboard?.instantiateViewController(identifier: "FavoriteSettingVC") as? FavoriteSettingVC else { return }
            
            langSetVC.modalTransitionStyle = .coverVertical
            langSetVC.modalPresentationStyle = .formSheet
            
            self.present(langSetVC, animated: true, completion: nil)
        default:
            return
        }
    }

}
