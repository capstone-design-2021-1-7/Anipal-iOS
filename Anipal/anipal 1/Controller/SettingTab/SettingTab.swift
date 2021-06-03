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

    let settings: [String] = ["Language".localized, "Favorite".localized, "Block List".localized]
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectedAnimal: Int = 0
    
    var animals: [AnimalPost] = []  // 서버 POST용
    var serverAnimals: [Animal] = [] // next page 데이터 전송용
    var images: [UIImage] = []
    var blockUsers: [String] = []
    var blockUserInfo: [User] = []
    var languageList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.setTitle("Logout".localized, for: .normal)
        
        // 동물 선택 버튼
        favBtn.backgroundColor = .white
        favBtn.layer.cornerRadius = favBtn.frame.height/2
//        favBtn.layer.borderWidth = 0.3
//        favBtn.layer.borderColor = UIColor.lightGray.cgColor
        favBtn.imageView?.contentMode = .scaleAspectFit
//        favBtn.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 30, right: 0)
        
        // 유저 이름
        nameLabel.text = ad?.name
        
        // 로그아웃 버튼
        logoutBtn.layer.shadowColor = UIColor.lightGray.cgColor
        logoutBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        logoutBtn.layer.shadowOpacity = 1.0
        logoutBtn.layer.shadowRadius = 3
        logoutBtn.layer.masksToBounds = false
        
        self.settingTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //settingTableView.frame = CGRect(x: settingTableView.frame.origin.x, y: settingTableView.frame.origin.y, width: settingTableView.bounds.width, height: settingTableView.rowHeight)
        loadAnimal()
        loadBlockUsers()
        favBtn.setImage(ad?.thumbnail, for: .normal)
    }
    
    func dataReceived(data: Int) {
        selectedAnimal = data
        ad?.thumbnail = animals[data].animalImg
        favBtn.setImage(ad?.thumbnail, for: .normal)
        
        // 변경된 대표 동물 이미지 서버 전송
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            let body: NSMutableDictionary = NSMutableDictionary()
            body.setValue(animals[data].animalURLs, forKey: "favorite_animal")

            let putURL = "/users/" + (ad?.id)!

            put(url: putURL, token: session.value, body: body, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        var json = JSON(data)
                        if json["mission"].dictionary != nil {
                            json = json["mission"]   
                            var detail: AccessoryDetail?
                            if let url = URL(string: json["img_url"].stringValue) {
                                if let imgData = try? Data(contentsOf: url) {
                                    if let image = UIImage(data: imgData) {
                                        detail = AccessoryDetail(name: json["name"].stringValue, price: json["price"].intValue, imgUrl: json["img_url"].stringValue, img: image, missionContent: json["mission"].stringValue, category: json["category"].stringValue)
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "Tab2", bundle: nil)
                                guard let missionVC = storyboard.instantiateViewController(identifier: "mission") as? MissionView else {return}
                                missionVC.accessoryInfo = detail
                                missionVC.okBtnTitle = "Get"
                                missionVC.modalPresentationStyle = .overCurrentContext
                                self.present(missionVC, animated: true, completion: nil)
                            }
                            
                        }
            
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        }
    }
    
    // 대표 동물 변경
    @IBAction func editAnimal(_ sender: UIButton) {
        let sub = UIStoryboard(name: "SignUp", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "selectAnimalVC") as? SelectAnimal else {
            return
        }
        
        nextVC.delegate = self
        nextVC.serverAnimals = self.serverAnimals
        nextVC.isThumbnail = true
        
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
        animals = []  // 서버 POST용
        serverAnimals = [] // next page 데이터 전송용
        images = []
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
    
    func loadBlockUsers() {
        blockUsers = ad?.blockUsers ?? []
        blockUserInfo = []
        var blockURL: String
        for id in 0..<blockUsers.count {
            if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
                blockURL = "/users/" + blockUsers[id]
                get(url: blockURL, token: session.value, completionHandler: { [self] data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse {
                        if httpStatus.statusCode == 200 {
                            let json = JSON(data)
                            languageList = []
                            let favorites = json["favorites"].arrayValue.map { $0.stringValue }
                            let languages = json["languages"].arrayObject as? [[String: Any]]
                            for row in languages ?? [] {
                                if let name = row["name"] as? String {
                                    languageList.append(name)
                                }
                            }
                            let animalURLs: [String: String] = [
                                "animal_url": json["favorite_animal"]["animal_url"].stringValue,
                                "head_url": json["favorite_animal"]["head_url"].stringValue,
                                "top_url": json["favorite_animal"]["top_url"].stringValue,
                                "pants_url": json["favorite_animal"]["pants_url"].stringValue,
                                "shoes_url": json["favorite_animal"]["shoes_url"].stringValue,
                                "gloves_url": json["favorite_animal"]["gloves_url"].stringValue
                            ]
                            let animalImg = loadAnimals(urls: animalURLs)
                            let userInfo = User(name: json["name"].stringValue, gender: json["gender"].stringValue, age: json["age"].uIntValue, birthday: json["birthday"].stringValue, email: json["email"].stringValue, favorites: favorites, languages: languageList, thumbnail: animalImg)
                            blockUserInfo.append(userInfo)
                        } else if httpStatus.statusCode == 400 {
                            print("error: \(httpStatus.statusCode)")
                        } else {
                            print("error: \(httpStatus.statusCode)")
                        }
                    }
                })
            }
        }
    }
}

extension SettingTab: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = UIColor(red: 0.95, green: 0.973, blue: 1, alpha: 1)
        
        return headerView
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
            langSetVC.modalPresentationStyle = .fullScreen
            
            self.present(langSetVC, animated: true, completion: nil)
        case 1: guard let favSetVC = self.storyboard?.instantiateViewController(identifier: "FavoriteSettingVC") as? FavoriteSettingVC else { return }
            
            favSetVC.modalTransitionStyle = .coverVertical
            favSetVC.modalPresentationStyle = .fullScreen
            
            self.present(favSetVC, animated: true, completion: nil)
        case 2: guard let blockSetVC = self.storyboard?.instantiateViewController(identifier: "BlockSettingVC") as? BlockSettingVC else { return }
            
            blockSetVC.modalTransitionStyle = .coverVertical
            blockSetVC.modalPresentationStyle = .fullScreen
            
            blockSetVC.blockedUsers = self.blockUserInfo
            self.present(blockSetVC, animated: true, completion: nil)
        default:
            return
        }
    }

}
