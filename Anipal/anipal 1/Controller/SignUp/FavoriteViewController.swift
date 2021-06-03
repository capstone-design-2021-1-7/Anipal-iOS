//
//  FavoriteViewController.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/05.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favLabelTitle: UILabel!
    @IBOutlet var favTable: FavoriteView!
    @IBOutlet var finishButton: UIButton!
    
    override func viewDidLoad() {
        favLabelTitle.text = "Choose your favorites.".localized
        favLabelTitle.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        super.viewDidLoad()
        finishButton.setTitle("Complete".localized, for: .normal) 
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        ad!.favorites = favTable.userFav
        postData(url: "https://anipal.co.kr/auth/register", token: ad!.token!)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager.init().logOut()
        self.navigationController?.popToRootViewController(animated: true)
        ad?.favorites = []
        ad?.languages = []
        ad?.favAnimal = ""
    }
    
    // 추후 리팩토링 완료예정.
//    func register() {
//        guard let ad = ad else {return}
//        let param = ["name": ad.name!, "gender": ad.gender!, "age": ad.age!, "birthday": ad.birthday!, "country": ad.country!, "provider": ad.provider!, "favorites": ad.favorites!, "languages": ad.languages!, "favorite_animal": ad.favAnimal!] as [String: Any]
//
//        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
//            post(url: "/auth/register", token: session.value, body: (param as? NSMutableDictionary)!, completionHandler: { [self] data, response, error in
//                guard let data = data, error == nil else {
//                    print("error=\(String(describing: error))")
//                    return
//                }
//
//                if let httpStatus = response as? HTTPURLResponse {
//                    if httpStatus.statusCode == 201 {
//                        DispatchQueue.main.async {
//                            print("post success")
//                            moveMainScreen()
//                        }
//                    } else if httpStatus.statusCode == 400 {
//                        DispatchQueue.main.async {
//                            print("이미 이메일이 존재합니다")
//                            GIDSignIn.sharedInstance()?.signOut()
//                            LoginManager.init().logOut()
//                            let alert = UIAlertController.init(title: "중복가입", message: "이미 가입된 이메일입니다 \n다른 소셜계정으로 다시 로그인해주세요!", preferredStyle: .alert)
//                            let okBtn = UIAlertAction.init(title: "확인", style: .default) { (_) in
//                                self.navigationController?.popToRootViewController(animated: true)
//                            }
//                            alert.addAction(okBtn)
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    } else {
//                        print("error : \(httpStatus.statusCode)")
//                    }
//                }
//            })
//        }
//    }
    
    func postData(url: String, token: String) {
        // 1. 전송할 값 준비
        guard let ad = ad else {return}
        let param = ["name": ad.name!, "gender": ad.gender!, "age": ad.age!, "birthday": ad.birthday!, "country": ad.country!, "provider": ad.provider!, "favorites": ad.favorites!, "languages": ad.languages!, "favorite_animal": ad.favAnimal!] as [String: Any] // JSON 객체로 변환할 딕셔너리 준비
        
        let paramData = try? JSONSerialization.data(withJSONObject: param, options: [])

        // 2. URL 객체 정의
        let url = URL(string: url)

        // 3. URLRequest 객체 정의 및 요청 내용 담기
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData

        // 4. HTTP 메시지에 포함될 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        // request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")

        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
                }
            
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode == 201 {
                    DispatchQueue.main.async {
                        print("post success")
                        moveMainScreen()
                    }
                } else if httpStatus.statusCode == 400 {
                    DispatchQueue.main.async {
                        print("이미 이메일이 존재합니다")
                        GIDSignIn.sharedInstance()?.signOut()
                        LoginManager.init().logOut()
                        let alert = UIAlertController.init(title: "중복가입", message: "이미 가입된 이메일입니다 \n다른 소셜계정으로 다시 로그인해주세요!", preferredStyle: .alert)
                        let okBtn = UIAlertAction.init(title: "확인", style: .default) { (_) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        alert.addAction(okBtn)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    print("error : \(httpStatus.statusCode)")
                }
            }
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
        }

        // 6. POST 전송
        task.resume()
    }
}
