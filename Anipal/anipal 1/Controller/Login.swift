//
//  ViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/03.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class Login: UIViewController {
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var appleBtn: UIButton!
    @IBOutlet var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        facebookBtn.layer.cornerRadius = 10
        googleBtn.layer.cornerRadius = 10
        googleBtn.layer.borderColor = UIColor.gray.cgColor
        googleBtn.layer.borderWidth = 1
        appleBtn.layer.cornerRadius = 10
        logoImage.layer.cornerRadius = logoImage.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func facebookLogin(_ sender: UIButton) {
        LoginManager.init().logIn(permissions: [Permission.publicProfile, Permission.email], viewController: self) {(loginResult) in
            switch loginResult {
            case .success(granted:_, declined:_, token:_):
                print("success facebook login")
                if let token = AccessToken.current, !token.isExpired {
                    print(token)
                // getData(url: "http://9075cd62c831.ngrok.io", token: user.authentication.accessToken) // 서버로 b토큰 전송
                    moveMainScreen()
                }
            case .cancelled:
                print("user cancel the login")
            case .failed(let error):
                print("error occured: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func appleLogin(_ sender: UIButton) {
    }
}
// MARK: - 구글 로그인 설정
extension Login: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // getData(url: "http://9075cd62c831.ngrok.io", token: user.authentication.accessToken) // 서버로 b토큰 전송
        moveMainScreen()
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}

// MARK: - 서버 통신
func getData(url: String, token: String) {
    
    // let parameters = ["access Token": user.authentication.accessToken, "name": "jack"] as [String : Any]

        // create the url with URL
        let url = URL(string: url)! // change the url
    
        // create the session object
        let session = URLSession.shared
    
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // set http method as POST

//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//            } catch let error {
//                print(error.localizedDescription)
//            }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        // request.addValue("application/json", forHTTPHeaderField: "Accept")

        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                // create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
}

// MARK: - 메인화면전환
func moveMainScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
}
