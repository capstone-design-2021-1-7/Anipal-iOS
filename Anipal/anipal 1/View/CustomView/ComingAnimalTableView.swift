//
//  ComingAnimalTableView.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit
import SwiftyJSON

class ComingAnimalTableView: UIView, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var comingAnimals: [ComingAnimal] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.comminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.comminInit()
        loadComingAnimals()
    }
    
    // View 초기화
    private func comminInit() {
        let bundle = Bundle.init(for: self.classForCoder)
        guard let view = bundle.loadNibNamed("ComingAnimalTableView", owner: self, options: nil)?.first as? UIView else {
            fatalError("Can't load ComingAnimalTableView")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        initTableView()
    }
    
    // Cell 초기화
    private func initTableView() {
        let nib = UINib(nibName: "ComingAnimalCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ComingAnimalCell")
        tableView.rowHeight = 90.0
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.dataSource = self
    }
    
    // 서버 데이터
    func loadComingAnimals() {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/letters/coming", token: session.value, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        comingAnimals = []
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let animalURL = json["coming_animal"]["animal_url"].stringValue
                            let bar = json["coming_animal"]["bar"].stringValue
                            let background = json["coming_animal"]["background"].stringValue
                            let arvTime = json["arrive_time"].stringValue
                            let sendTime = json["send_time"].stringValue
                            
                            let comingAnimal = ComingAnimal(animalURL: animalURL, bar: bar, background: background, arriveTime: arvTime, sendTime: sendTime)
                            comingAnimals.append(comingAnimal)
                        }
                        
                        // 화면 reload
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        }
    }
    
    // HEX Color convert
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func dateCalculate(start: String = "", end: String) -> Float {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let startTime: Date
        if start == "" {
            startTime = Date()
        } else {
            startTime = formatter.date(from: start)!
        }
        guard let endTime = formatter.date(from: end) else {
            return 0
        }
        
        let useTime = Float(endTime.timeIntervalSince(startTime))
        
        return useTime
    }
}

extension ComingAnimalTableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comingAnimals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComingAnimalCell", for: indexPath) as? ComingAnimalCell else {
            fatalError("Can't dequeue CommingAnimalCell")
        }
        
        // 남은 시간 계산
        let wholeTime = dateCalculate(start: comingAnimals[indexPath.row].sendTime, end: comingAnimals[indexPath.row].arriveTime)
        let comingTime = dateCalculate(end: comingAnimals[indexPath.row].arriveTime)
        let remainTime = Float((comingTime / wholeTime) * 100)
        cell.animalSlider.setValue(100 - remainTime, animated: true)
        
        // slider thumb 이미지
        let cellURL = URL(string: comingAnimals[indexPath.row].animalURL)
        let data = try? Data(contentsOf: cellURL!)
        let thumbImg = UIImage(data: data!)?.scalePreservingAspectRatio(targetSize: CGSize(width: 48, height: 48))
        cell.animalSlider.setThumbImage(thumbImg, for: .normal)
        cell.animalSlider.minimumTrackTintColor = hexStringToUIColor(hex: comingAnimals[indexPath.row].bar)
        cell.animalSlider.maximumTrackTintColor = hexStringToUIColor(hex: comingAnimals[indexPath.row].background)
        
        return cell
    }
}
