//
//  SelectAnimalPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

class SelectAnimalPage: UIViewController {

    var animalName: String?
    var animalImg: UIImage?
    
    @IBOutlet weak var collectionMain: UICollectionView!
    @IBOutlet var blurView: UIVisualEffectView!

    @IBOutlet var popupView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionMain.delegate = self
        collectionMain.dataSource = self
        // collectionMain.collectionViewLayout = UICollectionViewLayout()

        // 블러뷰 사이즈 전체사이즈와 맞춤
//        blurView.bounds = self.view.bounds
//        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.4)
    }

    @IBAction func sendAction(_ sender: UIButton) {
        if let safeAniname = animalName, let safeAniImg = animalImg {
            print(safeAniname)
            print(safeAniImg)
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    @IBAction func selectBtn(_ sender: UIButton) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        // animatedIn(desiredView: blurView)
        // animatedIn(desiredView: popupView)

 // 얼럿창 구현
        let alert = UIAlertController(title: "REAL?", message: "전송시 수정이 불가능합니다. 전송하시겠습니까?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {_ in self.navigationController?.popToRootViewController(animated: true) })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
extension SelectAnimalPage {

    func animatedIn(desiredView: UIView) {
        let backgroundView = self.view!
        
        // 스크린에 desired view 추가
        backgroundView.addSubview(desiredView)

        //
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
}

extension SelectAnimalPage: UICollectionViewDelegate, UICollectionViewDataSource {

    // 데이터수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }

    // 데이터 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectAnimal", for: indexPath) as! SelectAnimalCollectionViewCell
        cell.animalName.text = animals[indexPath.row].name
        cell.animalImage.image = animals[indexPath.row].img

        cell.layer.cornerRadius = 8
        cell.layer.backgroundColor = UIColor.gray.cgColor

        return cell
    }

    // 셀이 선택되었을때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        animalName = animals[indexPath.row].name
        animalImg = animals[indexPath.row].img

        print(indexPath.row)
    }

}

extension SelectAnimalPage: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 230)
    }
}
