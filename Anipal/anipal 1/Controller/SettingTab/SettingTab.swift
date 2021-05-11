//
//  SettingTab.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SwiftyJSON

class SettingTab: UIViewController, sendBackDelegate {
    
    let settings: [String] = ["Language".localized, "Favorite".localized]
    let sections: [String] = ["Language".localized, "Favorite".localized]
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var selectedAnimal: Int = 0
    
    var animals: [AnimalPost] = []  // 서버 POST용
    var serverAnimals: [Animal] = [] // next page 데이터 전송용
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.setTitle("Logout".localized, for: .normal)
        
        print("favAnimal: \(ad?.favAnimal)")
        
        // 동물 선택 버튼
        favBtn.backgroundColor = .white
        favBtn.layer.cornerRadius = favBtn.frame.height/2
        favBtn.layer.borderWidth = 0.3
        favBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        self.settingTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAnimal()
    }
    
    func dataReceived(data: Int) {
        selectedAnimal = data
        favBtn.setImage(animals[data].animalImg, for: .normal)
        favBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    // 대표 동물 변경
    @IBAction func editAnimal(_ sender: UIButton) {
        let sub = UIStoryboard(name: "SignUp", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "selectAnimalVC") as? SelectAnimal else {
            return
        }
        
        nextVC.delegate = self
        nextVC.serverAnimals = self.serverAnimals
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func clickLogoutBtn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager.init().logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        ad?.favorites = []
        ad?.languages = []
        ad?.favAnimal = ""
    }
    
    func loadAnimal() {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/own/animals", token: session.value, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let animalURLs: [String: String] = [
                                "animal_url": json["animal_url"].stringValue,
                                "head_url": json["head_url"].stringValue,
                                "top_url": json["top_url"].stringValue,
                                "pants_url": json["pants_url"].stringValue,
                                "shoes_url": json["shoes_url"].stringValue,
                                "gloves_url": json["gloves_url"].stringValue
                            ]
                            let animalImg = loadAnimals(urls: animalURLs)
                            let comingAnimal = [
                                "animal_url": json["coming_animal"]["animal_url"].stringValue,
                                "bar": json["coming_animal"]["bar"].stringValue,
                                "background": json["coming_animal"]["background"].stringValue
                            ]
                            let animal = AnimalPost(animal: json["animal"]["localized"].stringValue, animalURLs: animalURLs, isUsed: json["is_used"].boolValue, delayTime: json["delay_time"].stringValue, comingAnimal: comingAnimal, animalImg: animalImg, ownAnimalId: json["_id"].stringValue)
                            animals.append(animal)
                            serverAnimals.append(Animal(nameInit: json["animal"]["localized"].stringValue, image: animalImg))
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
    
    // MARK: - 이미지 합성
    func loadAnimals(urls: [String: String]) -> UIImage {
        let order = urls.sorted(by: <)
        images = []
        for (_, url) in order {
            setImage(from: url)
        }
        return compositeImage(images: images)
    }
    
    func compositeImage(images: [UIImage]) -> UIImage {
        var compositeImage: UIImage!
        if images.count > 0 {
            let size: CGSize = CGSize(width: images[0].size.width, height: images[0].size.height)
            UIGraphicsBeginImageContext(size)
            for image in images {
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                image.draw(in: rect)
            }
            compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return compositeImage
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.images.append(image!)
    }
}

extension SettingTab: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPageTableViewCell", for: indexPath) as? SettingTableView else { return UITableViewCell() }
        cell.settingLabel.text = settings[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0: guard let langSetVC = self.storyboard?.instantiateViewController(identifier: "LanguageSettingVC") as? LanguageSettingVC else { return }
            
            langSetVC.modalTransitionStyle = .coverVertical
            langSetVC.modalPresentationStyle = .formSheet
            
            self.present(langSetVC, animated: true, completion: nil)
        case 1: guard let langSetVC = self.storyboard?.instantiateViewController(identifier: "FavoriteSettingVC") as? FavoriteSettingVC else { return }
            
            langSetVC.modalTransitionStyle = .coverVertical
            langSetVC.modalPresentationStyle = .formSheet
            
            self.present(langSetVC, animated: true, completion: nil)
        default:
            return
        }
    }

}
