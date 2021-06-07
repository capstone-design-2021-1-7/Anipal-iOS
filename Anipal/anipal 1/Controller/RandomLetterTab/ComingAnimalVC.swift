//
//  CommingAnimalVC.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/16.
//

import UIKit

class ComingAnimalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let data = [ "Rabbit", "Turtle", "Cat", "Dog" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComingAnimalViewCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
