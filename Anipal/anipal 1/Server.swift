//
//  Server.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/18.
//

import Foundation
import UIKit

let session: URLSession = URLSession.shared

func get(url: String, token: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard let url = URL(string: "http://ec2-15-164-231-148.ap-northeast-2.compute.amazonaws.com" + url) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    
    session.dataTask(with: request as URLRequest, completionHandler: completionHandler).resume()
}

func post(url: String, token: String, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    guard let url = URL(string: "http://ec2-15-164-231-148.ap-northeast-2.compute.amazonaws.com" + url) else {
        print("url error")
        return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
    session.dataTask(with: request, completionHandler: completionHandler).resume()
    
}

func put(url: String, token: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard let url = URL(string: "http://ec2-15-164-231-148.ap-northeast-2.compute.amazonaws.com" + url) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: completionHandler).resume()
}

//func post(url: String, token: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//    guard let url = URL(string: "http://ec2-15-164-231-148.ap-northeast-2.compute.amazonaws.com" + url) else { return }
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//
//    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: completionHandler).resume()
// }
