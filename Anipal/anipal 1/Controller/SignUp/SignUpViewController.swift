//
//  SignUpViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SwiftyJSON

let ad = UIApplication.shared.delegate as? AppDelegate // 회원가입 데이터 임시저장
class SignUpViewController: UIViewController, sendBackDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var genderChoice: UISegmentedControl!
    @IBOutlet var imgButton: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet var nextButton: UIButton!
    var selectNum = 0
    var serverAnimals: [Animal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnimal()
        textLocalize()
        
        // Make imgButton Circle
//        imgButton.layer.borderWidth = 1
//        imgButton.layer.masksToBounds = false
//        imgButton.layer.borderColor = UIColor.gray.cgColor
//        imgButton.layer.cornerRadius = imgButton.frame.height/2
//        imgButton.clipsToBounds = true
        self.dateField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAnimal" {
            guard let secondVC = segue.destination as? SelectAnimal else {
                return
            }
            secondVC.delegate = self
            secondVC.serverAnimals = self.serverAnimals
            secondVC.isThumbnail = true
        }
    }
    func dataReceived(data: Int) {
        imgButton.setBackgroundImage(serverAnimals[data].img, for: . normal)
        selectNum = data
        ad?.thumbnail = serverAnimals[data].img
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "signupVC2") else {
            return
        }
        
        if let newName = nameLabel.text {
            ad?.name = newName
        }
        var bE: Int!
        if let newBirth = dateField.text {
            ad?.birthday = newBirth
            
            let endIdx: String.Index = newBirth.index(newBirth.startIndex, offsetBy: 3)
            let birthYear = String(newBirth[...endIdx])
            bE = Int(birthYear)
            ad?.age = 2021-bE
        }

        if genderChoice.selectedSegmentIndex == 0 {
            ad?.gender = "femail"
        } else {
            ad?.gender = "male"
        }
        
        ad?.favAnimal = serverAnimals[selectNum].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // For datePicker
    @objc func tapDone() {
        if let datePicker = self.dateField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            // dateformatter.dateStyle = .medium
            self.dateField.text = dateformatter.string(from: datePicker.date)
        }
        self.dateField.resignFirstResponder()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager.init().logOut()
        self.navigationController?.popToRootViewController(animated: true)
        ad?.favorites = []
        ad?.languages = []
        ad?.favAnimal = ""
    }
    
    func textLocalize() {
        titleLabel.text = "Please enter your information.".localized
        nameLabel.placeholder = "Please enter your name".localized
        nextButton.setTitle("Next".localized, for: .normal)
        genderChoice.setTitle("Femail".localized, forSegmentAt: 0)
        genderChoice.setTitle("Mail".localized, forSegmentAt: 1)
    }
    
    func loadAnimal() {
            get(url: "/animals/basic", token: "", completionHandler: { [self]data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                            for idx in 0..<JSON(data).count {
                                let json = JSON(data)[idx]
                                let name = json["localized"].stringValue
                                let id = json["_id"].stringValue
                                let strURL = json["img_url"].stringValue
                                guard let imageURL = URL(string: strURL) else {return}
                                guard let imageData = try? Data(contentsOf: imageURL) else {return}
                                guard let img = UIImage(data: imageData) else {return}
                                serverAnimals.append(Animal(nameInit: name, image: img, animalId: id))
                            }
                        // 화면 load
                        DispatchQueue.main.async {
                            imgButton.setBackgroundImage(serverAnimals[0].img, for: .normal)
                            // imgButton.setImage(serverAnimals[0].img, for: .normal)
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
// MARK: - 데이트피커 텍스트필드안에 넣기
extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
                
            let date = DateFormatter()
            date.locale = Locale(identifier: "ko_kr")
            date.dateFormat = "yyyy-MM-dd"
            
            // 최소, 최대 년도 설정
            let maxTime = date.date(from: "2017-12-31")
            let minTime = date.date(from: "1990-01-01")
            datePicker.maximumDate = maxTime
            datePicker.minimumDate = minTime
        }
        self.inputView = datePicker
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
