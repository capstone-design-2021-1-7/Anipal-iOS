//
//  SingUpViewController2.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SwiftyJSON
class SignUpViewController2: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageTableView: UITableView!
    @IBOutlet var nextButton: UIButton!
    
//    let languageList = ["English", "한국어", "日本語", "中文", "Italiano", "프랑스어", "포르투갈어"]
    var serverLanguage: [String] = []
    var myLanguageList: [String: Int]! = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageTableView.delegate = self
        languageTableView.dataSource = self
        titleLabel.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        loadLanguage()
        viewSettingLayout()
        
        // 저장 데이터 -> 화면 데이터 변환
        for row in ad?.languages ?? [] {
            if let name = row["name"] as? String, let level = row["level"] as? Int {
                myLanguageList[name] = level
            }
        }
            
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FavoriteVC") else {
            return
        }
        
        // 화면데이터 -> 저장데이터 변환
        var templanguages: [[String: Any]]? = [[String: Any]]()
        for row in myLanguageList ?? [:] {
            let (lang, level) = row
            print(lang, level)
            templanguages?.append(["name": lang, "level": level])
        }
        
        ad?.languages = templanguages
        print(ad!.languages!)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager.init().logOut()
        self.navigationController?.popToRootViewController(animated: true)
        ad?.favorites = []
        ad?.languages = []
        ad?.favAnimal = ""
    }
    
    func viewSettingLayout() {
        titleLabel.text = "Choose your language.".localized
        nextButton.setTitle("Next".localized, for: .normal)
    }
    
    // 서버 데이터 로드
    func loadLanguage() {
        get(url: "/languages", token: "", completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode == 200 {
                    for idx in 0..<JSON(data).count {
                        let json = JSON(data)[idx]
                        let langname = json["name"].stringValue
                        serverLanguage.append(langname)
                    }
                    // 화면 reload
                    DispatchQueue.main.async {
                        self.languageTableView.reloadData()
                    }
                } else if httpStatus.statusCode == 400 {
                    print("error: \(httpStatus.statusCode)")
                } else {
                    print("error: \(httpStatus.statusCode)")
                }
            }
        })
    }
}
    
extension SignUpViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as? LanguageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.languageName.text = serverLanguage[indexPath.row].localized
        cell.languageName.textColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        cell.languageLevel.textColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        
        cell.checkBox.layer.borderWidth = 1
        cell.checkBox.layer.borderColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1).cgColor
        cell.checkBox.layer.cornerRadius = 5
        cell.checkBox.clipsToBounds = true
        cell.checkBox.backgroundColor = .white
        
        if myLanguageList.keys.contains(serverLanguage[indexPath.row]) {
            cell.checkBox.image = #imageLiteral(resourceName: "checkBox")
            let level = myLanguageList[serverLanguage[indexPath.row]]!
            if level == 1 {
                cell.languageLevel.text = "Beginner".localized
            } else if level == 2 {
                cell.languageLevel.text = "Intermediate".localized
            } else {
                cell.languageLevel.text = "Advanced".localized
            }
            
        } else {
            cell.checkBox.image = #imageLiteral(resourceName: "emptyCheckBox")
            cell.languageLevel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if myLanguageList.keys.contains(serverLanguage[indexPath.row]) {
            myLanguageList.removeValue(forKey: serverLanguage[indexPath.row])
            self.languageTableView.reloadData()
        } else {
            
            let alertcontroller = UIAlertController(title: "Level".localized, message: nil, preferredStyle: .actionSheet)
            let basicBtn = UIAlertAction(title: "Beginner".localized, style: .default) { (_) in
                self.myLanguageList[self.serverLanguage[indexPath.row]] = 1
                self.languageTableView.reloadData()
            }
            let mediumBtn = UIAlertAction(title: "Intermediate".localized, style: .default) { (_) in
                self.myLanguageList[self.serverLanguage[indexPath.row]] = 2
                self.languageTableView.reloadData()
            }
            let intermediateBtn = UIAlertAction(title: "Advanced".localized, style: .default) { (_) in
                self.myLanguageList[self.serverLanguage[indexPath.row]] = 3
                self.languageTableView.reloadData()
            }
            
            let cancelBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alertcontroller.addAction(basicBtn)
            alertcontroller.addAction(mediumBtn)
            alertcontroller.addAction(intermediateBtn)
            alertcontroller.addAction(cancelBtn)
            present(alertcontroller, animated: true, completion: nil)
        }
    }
}
