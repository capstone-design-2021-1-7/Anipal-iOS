//
//  FavoriteView.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/03.
//

import  UIKit
import SwiftyJSON

protocol FavoriteViewDelegate {
    func eventFavoriteView()
}

@IBDesignable
class FavoriteView: UIView, UICollectionViewDataSource {
    public var delegate: FavoriteViewDelegate?
    
    var userFav: [String] = ad?.favorites ?? []
    var serverFavorites: [String] = []
    
    @IBOutlet var favView: UIView!
    @IBOutlet weak var favCell: UICollectionView!
    @IBOutlet var favCollectionVeiw: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        loadFavorites()
    }
    // View 초기화
    private func commonInit() {
        let bundle = Bundle.init(for: self.classForCoder)
        guard let view = bundle.loadNibNamed("FavoriteView", owner: self, options: nil)?.first as? UIView else {
            fatalError("Can't load FavoriteView")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        initCollectionView()
    }
    
    // Cell 초기화
    private func initCollectionView() {
        let nib = UINib(nibName: "FavoriteCell", bundle: nil)
        favCell.register(nib, forCellWithReuseIdentifier: "FavCell")
        favCell.dataSource = self
    }
    
    func loadFavorites() {
        get(url: "/favorites", token: "", completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode == 200 {
                    for idx in 0..<JSON(data).count {
                        let json = JSON(data)[idx]
                        let langname = json["name"].stringValue
                        serverFavorites.append(langname)
                    }
                    // 화면 reload
                    DispatchQueue.main.async {
                        self.favCollectionVeiw.reloadData()
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

extension FavoriteView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serverFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as? FavoriteCell else {
            fatalError("Can't dequeue FavCell")
        }
        cell.favBtn.setTitle(serverFavorites[indexPath.row].localized, for: .normal)
        cell.favBtn.layer.cornerRadius = 5
        
        if userFav.contains(serverFavorites[indexPath.row]) {
            cell.favBtn.layer.backgroundColor = CGColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        } else {
            cell.favBtn.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        cell.favBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // 버튼 액션
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(favBtnClick), for: .touchUpInside)
        
        return cell
    }
    
    @objc func favBtnClick(sender: UIButton) {
        let favData = serverFavorites[sender.tag]
        
        // 선택
        if userFav.contains(favData) {
            if let idx = userFav.firstIndex(of: favData) {
                userFav.remove(at: idx)
            }
            sender.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        } else {    // 선택 해제
            userFav.append(favData)
            sender.layer.backgroundColor = CGColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        }

    }
    
}
