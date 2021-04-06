//
//  SignUpViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit

class SignUpViewController: UIViewController, sendBackDelegate {
    
    @IBOutlet var dateField: UITextField!
    @IBOutlet var genderChoice: UISegmentedControl!
    @IBOutlet var imgButton: UIButton!
    let initAnimals: [Animal] = [
        Animal(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
        Animal(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
        Animal(nameInit: "panda", image: #imageLiteral(resourceName: "panda"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UINavigationBar.appearance().barTintColor = UIColor(red: 174, green: 192, blue: 245, alpha: 1)
        
        // Make imgButton Circle
        imgButton.layer.borderWidth = 1
        imgButton.layer.masksToBounds = false
        imgButton.layer.borderColor = UIColor.gray.cgColor
        imgButton.layer.cornerRadius = imgButton.frame.height/2
        imgButton.clipsToBounds = true
        
        self.dateField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAnimal" {
            let secondVC = segue.destination as! SelectAnimal
            secondVC.delegate = self
        }
    }
    
    func dataReceived(data: Int) {
        imgButton.setImage(animals[data].img, for: . normal)
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "signupVC2") else {
            return
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // For datePicker
    @objc func tapDone() {
        if let datePicker = self.dateField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.dateField.text = dateformatter.string(from: datePicker.date)
        }
        self.dateField.resignFirstResponder()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
            let maxTime = date.date(from: "2017-01-01")
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
