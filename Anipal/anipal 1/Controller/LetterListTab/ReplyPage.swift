//
//  replyPage.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/01.
//

import UIKit
import SwiftyJSON

protocol reloadDelegate {
    func reloadDelegate()
}

class ReplyPage: UIViewController, sendBackDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var animalBtn: UIButton!
    // @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!

    var receiverID: String?
    var postURL: String?
    var selectedAnimal: Int = 0
    var delegate: reloadDelegate?
    
    var animals: [AnimalPost] = []  // 서버 POST용
    var serverAnimals: [Animal] = [] // next page 데이터 전송용
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderSetting()
        
        // 동물 선택 버튼
        animalBtn.backgroundColor = .white
        animalBtn.layer.cornerRadius = animalBtn.frame.height/2
        animalBtn.layer.borderWidth = 0.3
        animalBtn.layer.borderColor = UIColor.lightGray.cgColor
//        animalBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        // 저장&전송 버튼
//        saveBtn.setTitle("Save".localized, for: .normal)
//        setBtnUI(btn: saveBtn)
        sendBtn.setTitle("Send".localized, for: .normal)
        setBtnUI(btn: sendBtn)
        
        // 닫기 버튼
        if self.modalPresentationStyle == .fullScreen {
            closeBtn.isHidden = false
        } else {
            closeBtn.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadAnimal()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func closeModal(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dataReceived(data: Int) {
        selectedAnimal = data
        animalBtn.setImage(animals[data].animalImg, for: .normal)
        animalBtn.imageView?.contentMode = .scaleAspectFit
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
                            serverAnimals.append(Animal(nameInit: json["animal"]["localized"].stringValue, image: animalImg, animalId: json["_id"].stringValue, aniTime: json["delay_time"].stringValue))
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

    @IBAction func selectAnimalBtn(_ sender: UIButton) {
        let sub = UIStoryboard(name: "SignUp", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "selectAnimalVC") as? SelectAnimal else {
            return
        }
        nextVC.delegate = self
        nextVC.serverAnimals = self.serverAnimals
        nextVC.animals = self.animals
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func sendDataBtn(_ sender: UIButton) {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            let body: NSMutableDictionary = NSMutableDictionary()
            body.setValue(textView.text, forKey: "content")
            body.setValue(animals[selectedAnimal].ownAnimalId, forKey: "own_animal_id")
            
            if (postURL == "/letters") {
                body.setValue(receiverID, forKey: "receiver")
            }
            
            try? post(url: postURL!, token: session.value, body: body, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                // 미션 성공시
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
                        let storyboard = UIStoryboard(name: "CustomizeTab", bundle: nil)
                        guard let missionVC = storyboard.instantiateViewController(identifier: "mission") as? MissionView else {return}
                        missionVC.accessoryInfo = detail
                        missionVC.okBtnTitle = "Get"
                        missionVC.modalPresentationStyle = .overCurrentContext
//                        self.delegate?.reloadDelegate()
                        guard let pvc = self.presentingViewController else {return}
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            pvc.present(missionVC, animated: true, completion: nil)
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                print(String(data: data, encoding: .utf8)!)
            })
        }
        delegate?.reloadDelegate()
    }
}

// MARK: - 편지내용
extension ReplyPage: UITextViewDelegate {

    // placeholder
    func placeholderSetting() {
        textView.delegate = self
        textView.text = "Enter the content"
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    // 버튼 ui
    func setBtnUI(btn: UIButton) {
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 3
        btn.layer.masksToBounds = false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "Enter the content"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }

        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
