//
//  SelectAnimal1.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/10.
//

import UIKit

protocol sendBackDelegate1 {
    func dataReceived(data: Int)
}

class SelectAnimal1: UIViewController {

    var select = 0
    var delegate: sendBackDelegate1?
    @IBOutlet var collectionView: UICollectionView!
    let animalSelectCellId = "AnimalSelectCell"
    let initAnimals: [Animal] = [
        Animal(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
        Animal(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
        Animal(nameInit: "panda", image: #imageLiteral(resourceName: "panda"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
        
        // 셀등록
        let nibCell = UINib(nibName: "AnimalCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: animalSelectCellId)
        collectionView.reloadData()
    }
 
}

extension SelectAnimal1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return initAnimals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: animalSelectCellId, for: indexPath) as? AnimalCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.img.image = initAnimals[indexPath.row].img
        cell.name.text = initAnimals[indexPath.row].name
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        return cell
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.dataReceived(data: indexPath.row)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    // 섹션의 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 25
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    // 셀 행의 최소간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    // 셀의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 190)
    }
    
}
