//
//  AppDelegate.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/03.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var provider: String?
    var id: String?
    var name: String?
    var age: Int?
    var favAnimal: String? = ""
    var thumbnail: UIImage?
    var email: String?
    var country: String? = "Korea"
    var birthday: String?
    var gender: String?
    var favorites: [String]?
    var languages: [[String: Any]]? = [[String: Any]]() // [["name": "한국어", "level": 1], ["name": "Italiano", "level": 3]]
    var token: String?
    var accessories: [String: [[String: String]]]? 
    var animals: [[String: Any]]?
    var blockUsers: [String] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Google
        GIDSignIn.sharedInstance().clientID = "609953406443-h7c70g1bgk89t41ap53bdnvr6shrggr7.apps.googleusercontent.com"
        
        // Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url))! || ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
