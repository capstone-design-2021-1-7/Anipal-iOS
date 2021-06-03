//
//  MyAnimalPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/09.
//

import UIKit
import SwiftyJSON

class MyAnimalPage: UIViewController, reloadData {
    func reloadData() {
        refreshData()
    }

    @IBOutlet var animalCollectionView: UICollectionView!
    let cellId = "MyAnimalPageCollectionViewCell"
   // let cellId = "AnimalSelectCell"

    var myAnimalList: [MyAnimal] = []
    var imageUrls: [[String]] = []
    var images: [UIImage] = []
    var order: [String: Int] = ["head": 1, "top": 2, "pants": 3, "shoes": 4, "gloves": 5 ]
    var needReload: Bool = false
    
    var serverHead: [Accessory] = []
    var serverData: [Int: [Accessory]] = [:]
    var num = 0
    var baseAnimalImage: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animalCollectionView.delegate = self
        animalCollectionView.dataSource = self
        // 셀 등록
        let nibCell = UINib(nibName: "MyAnimalPageCollectionViewCell", bundle: nil)
        animalCollectionView.register(nibCell, forCellWithReuseIdentifier: cellId )
        animalCollectionView.reloadData()
        refreshData()
//        loadAccessories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAccessories()
        animalCollectionView.reloadData()
        // 네이베이션바 선 없애기
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animalCollectionView.reloadData()
    }

    // MARK: - 이미지 합성
    func compositeImage(images: [UIImage]) -> UIImage {
        var compositeImage: UIImage?
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
        return compositeImage ?? #imageLiteral(resourceName: "emptyCheckBox")
    }
    
    // 초기화
    func reset() {
        myAnimalList = []
        imageUrls = []
        images = []
    }
    
    func refreshData() {
        reset()
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/own/animals", token: session.value) { [self] (data, response, error) in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let animal: [String: String] = [
                                "animal_url": json["animal_url"].stringValue,
                                "head_url": json["head_url"].stringValue,
                                "top_url": json["top_url"].stringValue,
                                "pants_url": json["pants_url"].stringValue,
                                "shoes_url": json["shoes_url"].stringValue,
                                "gloves_url": json["gloves_url"].stringValue]
                            self.myAnimalList.append(MyAnimal(id: json["_id"].stringValue, time: json["animal"]["delay_time"].stringValue, name: json["animal"]["localized"].stringValue, animal: animal))
                        }
                        
                        // 이미지url 저장배열 생성 및 동물사진url 첫번쨰로 위치
                        if imageUrls.count != myAnimalList.count {
                            // imageUrls = []
                            for i in 0..<myAnimalList.count {
                                let sortedUrl = myAnimalList[i].animal.sorted(by: <)
                                var temp: [String] = []
                                
                                for row in sortedUrl {
                                    temp.append(row.value)
                                }
                                imageUrls.append(temp)
                                temp = []
                            }
                        }
    
                        
                        // url -> 이미지로 변환 후 합성 및 저장
                        for i in 0..<imageUrls.count {
                            var ingredImage: [UIImage] = []
                            // 기본동물
                            if let imageURL = URL(string: imageUrls[i][0]) {
                                if let imageData = try? Data(contentsOf: imageURL) {
                                    if let img = UIImage(data: imageData) {
                                        baseAnimalImage.append(img)
                                    }
                                }
                            }
                            // 꾸며진 동물
                            for url in imageUrls[i] {
                                if let imageURL = URL(string: url) {
                                    if let imageData = try? Data(contentsOf: imageURL) {
                                        if let img = UIImage(data: imageData) {
                                            ingredImage.append(img)
                                        }
                                    }
                                }
                            }
                            images.append(compositeImage(images: ingredImage))
                            ingredImage = []
                        }
                        
                        // 뷰 생성
                        DispatchQueue.main.async {
                            animalCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // 모든 악세서리 로드
    func loadAccessories() {
        loadAccessory(category: "head")
        loadAccessory(category: "top")
        loadAccessory(category: "pants")
        loadAccessory(category: "shoes")
        loadAccessory(category: "gloves")
    }
    
    // 악세서리 로드 함수
    func loadAccessory(category: String) {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/accessories/all/\(category)", token: session.value) { [self] (data, response, error) in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        var temp: [Accessory] = []
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            if let imageURL = URL(string: json["img_url"].stringValue) {
                                if let imageData = try? Data(contentsOf: imageURL) {
                                    if let img = UIImage(data: imageData) {
                                        temp.append(Accessory(accessoryId: json["accessory_id"].stringValue, imgUrl: json["img_url"].stringValue, isOwn: json["is_own"].boolValue, img: img))
                                    }
                                }
                            }
                        }
                        // 부위별 순서 기록
                        guard let num = order[category] else {return}
                        serverData[num] = temp
                        temp = []
                    }
                }
            }
        }
    }
}
extension MyAnimalPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = animalCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyAnimalPageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.animalName.text = myAnimalList[indexPath.row].name.localized
        cell.delayTime.text = myAnimalList[indexPath.row].time
        cell.animalImage.image = images[indexPath.row]
        return cell
    }
    
    // 셀 클릭시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let customVC = self.storyboard?.instantiateViewController(identifier: "customVC") as? AnimalCustom else {return}
        customVC.serverData = [serverData[1]!, serverData[2]!, serverData[3]!, serverData[4]!, serverData[5]!]
        customVC.myCharacterUrls = [imageUrls[indexPath.row][0], imageUrls[indexPath.row][2], imageUrls[indexPath.row][5], imageUrls[indexPath.row][3], imageUrls[indexPath.row][4], imageUrls[indexPath.row][1]]
        customVC.animalId = myAnimalList[indexPath.row].id
        customVC.delegate = self
        customVC.baseImage = baseAnimalImage[indexPath.row]
        customVC.delayTime = myAnimalList[indexPath.row].time
        customVC.animalName = myAnimalList[indexPath.row].name
        self.navigationController?.pushViewController(customVC, animated: true)
    }
    
    // 섹션의 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 25
        return UIEdgeInsets(top: 10, left: inset, bottom: inset, right: inset)
    }
    
    // 셀 행의 최소간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    // 셀의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 230)
    }
    
}
