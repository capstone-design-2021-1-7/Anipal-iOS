//
//  LetterDetailViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit
import SwiftyJSON

class LetterDetailViewController: UIViewController, UIScrollViewDelegate, reloadDelegate {
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderCountry: UILabel!
    @IBOutlet weak var senderFav: UILabel!
    @IBOutlet weak var senderAnimal: UIImageView!
    @IBOutlet weak var letterCtrl: UIPageControl!
    @IBOutlet weak var replyBtn: UIButton!
    
    var letters: [Letter] = []
    var mailBoxID: String?
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션
        self.navigationItem.title = "Letter".localized
        self.navigationItem.rightBarButtonItem = menuBtn
        
        // 답장 버튼
        replyBtn.setTitle("Reply".localized, for: .normal)
        replyBtn.layer.shadowColor = UIColor.lightGray.cgColor
        replyBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        replyBtn.layer.shadowOpacity = 1.0
        replyBtn.layer.shadowRadius = 3
        replyBtn.layer.masksToBounds = false
        
        // 편지 로딩
        getLetters()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//    }
    
    func reloadDelegate() {
        getLetters()
    }
    
    @IBAction func writeBtn(_ sender: UIButton) {
        guard let replyVC = self.storyboard?.instantiateViewController(identifier: "ReplyPage") as? ReplyPage else { return }
        
        replyVC.modalTransitionStyle = .coverVertical
        replyVC.modalPresentationStyle = .pageSheet
        
        replyVC.delegate = self
        replyVC.receiverID = letters[letterCtrl.currentPage].senderID
        replyVC.postURL = "/letters"
        
        self.present(replyVC, animated: true, completion: nil)
    }

    func setLetters() {
        // 편지 본문 로딩
        letterCtrl.numberOfPages = letters.count
        letterCtrl.currentPage = letterCtrl.numberOfPages - 1
        
        senderInfo()
        
        // 페이지 컨트롤 UI
        letterCtrl.hidesForSinglePage = true
        letterCtrl.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        letterCtrl.pageIndicatorTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        letterCtrl.currentPageIndicatorTintColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        
        // 편지 내용
        for idx in 0..<letters.count {
            let xPos = scrollViewContent.frame.size.width * CGFloat(idx)
            let textView = UITextView(frame: CGRect(x: xPos, y: 0, width: scrollViewContent.frame.size.width, height: scrollViewContent.frame.size.height))
            textView.layer.cornerRadius = 10
            textView.isEditable = false
            textView.text = letters[idx].content
            textView.font = UIFont.systemFont(ofSize: 16)
            
            scrollViewContent.contentSize.width = scrollViewContent.frame.size.width * CGFloat(idx + 1)
            scrollViewContent.addSubview(textView)
        }
        
        scrollViewContent.delegate = self
        // 최신 편지
        scrollViewContent.contentOffset.x = CGFloat((Int(scrollViewContent.contentSize.width) / letters.count) * (letters.count - 1))
        // 스크롤 바 숨김
        scrollViewContent.showsVerticalScrollIndicator = false
        scrollViewContent.showsHorizontalScrollIndicator = false
    }
    
    // 보낸 사용자 정보
    func senderInfo() {
        senderName.text = letters[letterCtrl.currentPage].name
        senderName.sizeToFit()
        senderCountry.text = letters[letterCtrl.currentPage].country
        senderCountry.sizeToFit()
        for (idx, fav) in letters[letterCtrl.currentPage].favorites.enumerated() {
            letters[letterCtrl.currentPage].favorites[idx] = fav.localized
        }
        senderFav.text = letters[letterCtrl.currentPage].favorites.joined(separator: " ")
        senderFav.sizeToFit()
        senderAnimal.image = letters[letterCtrl.currentPage].animalImg
        senderAnimal.contentMode = .scaleAspectFit
        
        senderAnimal.backgroundColor = .white
        senderAnimal.layer.cornerRadius = senderAnimal.frame.height/2
        senderAnimal.layer.borderWidth = 0.3
        senderAnimal.layer.borderColor = UIColor.lightGray.cgColor
        
        // 보낸 편지 답장 버튼 숨기기
        if letters[letterCtrl.currentPage].senderID == ad?.id {
            replyBtn.isHidden = true
        } else {
            replyBtn.isHidden = false
        }
    }
    
    func getLetters() {
        // Authorization 쿠키 확인 & 데이터 로딩
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            let url = "/mailboxes/show/" + mailBoxID!
            get(url: url, token: session.value, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        letters = []
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let senderID = json["sender"]["user_id"].stringValue
                            
                            let favorites = json["sender"]["favorites"].arrayValue.map { $0.stringValue }
                            let animal = [json["post_animal"]["animal_url"].stringValue, json["post_animal"]["head_url"].stringValue, json["post_animal"]["top_url"].stringValue, json["post_animal"]["pants_url"].stringValue, json["post_animal"]["gloves_url"].stringValue, json["post_animal"]["shoes_url"].stringValue]
                            let animalImg = loadAnimals(urls: animal)
                            let letter = Letter(
                                senderID: senderID,
                                name: json["sender"]["name"].stringValue,
                                country: json["sender"]["country"].stringValue,
                                favorites: favorites, animal: animal, receiverID: json["_id"].stringValue,
                                content: json["content"].stringValue,
                                arrivalDate: json["arrive_time"].stringValue,
                                sendDate: json["send_time"].stringValue,
                                animalImg: animalImg)
                            letters.append(letter)
                        }
                        
                        // 화면 reload
                        DispatchQueue.main.async {
                            setLetters()
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
    
    // 편지 넘기기
    @IBAction func letterSlide(_ sender: UIPageControl) {
        scrollViewContent.contentOffset.x = CGFloat((Int(scrollViewContent.contentSize.width) / letters.count) * letterCtrl.currentPage)
        senderFav.text = letters[letterCtrl.currentPage].favorites.joined(separator: " ")
    }
    
    @IBAction func letterMenu(_ sender: Any) {
        let alertcontroller = UIAlertController(title: "Menu".localized, message: nil, preferredStyle: .actionSheet)
        let deleteBtn = UIAlertAction(title: "Delete".localized, style: .default)
        let blockBtn = UIAlertAction(title: "Block".localized, style: .default)
        let cancelBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertcontroller.addAction(deleteBtn)
        alertcontroller.addAction(blockBtn)
        alertcontroller.addAction(cancelBtn)
        present(alertcontroller, animated: true, completion: nil)
    }
    
    // MARK: - 이미지 합성
    func loadAnimals(urls: [String]) -> UIImage {
        images = []
        for url in urls {
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

extension LetterDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        letterCtrl.currentPage = Int(floor(scrollViewContent.contentOffset.x / scrollViewContent.frame.size.width))
        senderInfo()
    }
}
