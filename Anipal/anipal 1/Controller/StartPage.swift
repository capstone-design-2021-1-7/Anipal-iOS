//
//  StartPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class StartPage: UIViewController {

    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
//       UINavigationBar.appearance().barTintColor = UIColor(red: 174, green: 192, blue: 245, alpha: 1)
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 구글 로그인여부 확인
        loginBtn.layer.cornerRadius = 10
        signupBtn.layer.cornerRadius = 10
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.95, green: 0.973, blue: 1, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        
        // 네이베이션바 선 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // 페이스북 로그인여부 확인
        if let token = AccessToken.current, !token.isExpired {
            print("facebook auto login")
            Profile.loadCurrentProfile { (profile, error) in
                print(profile?.email)
                print(profile?.name)
                print(profile?.userID)
            }
            moveMainScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
// MARK: - 회원가입버튼
    @IBAction func clickSignupBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let signupVC = storyboard.instantiateViewController(identifier: "SignUpVC1") as? SignUpViewController else {
            return
        }

        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
// MARK: - 로그인버튼
    
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        
        guard let loginVC = self.storyboard?.instantiateViewController(identifier: "GoogleLogin") else {
            return
        }
        
        // loginVC.modalTransitionStyle = .coverVertical
        // loginVC.modalPresentationStyle = .fullScreen
        // self.present(loginVC, animated: true)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
    
// MARK: - 구글 로그인 설정
extension StartPage: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        //
        
        guard let email = user.profile.email, email != "" else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    }
}
