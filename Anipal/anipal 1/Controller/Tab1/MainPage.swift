//
//  MainPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit
import SwiftyJSON

class MainPage: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var comingAnimals: ComingAnimals!
    var visualEffectView: UIVisualEffectView!
    
    let cardHandleAreaHeight: CGFloat = 120
    var cardHeight: CGFloat = 234
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    // 서버 데이터
    var receiveAnimal: [RandomAnimal] = []
    var imageUrls: [[String]] = []
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        refreshData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - 배송 중 동물
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        visualEffectView.layer.zPosition = 999
        self.view.addSubview(visualEffectView)
        
        comingAnimals = ComingAnimals(nibName: "ComingAnimals", bundle: nil)
        self.addChild(comingAnimals)
        comingAnimals.view.layer.zPosition = 999
        self.view.addSubview(comingAnimals.view)
        
        comingAnimals.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        comingAnimals.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPage.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainPage.handleCardPan(recognizer:)))
        
        comingAnimals.handleArea.addGestureRecognizer(tapGestureRecognizer)
        comingAnimals.handleArea.addGestureRecognizer(panGestureRecognizer)
        comingAnimals.handleArea.layer.cornerRadius = 12
    }
    
    @objc
    func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            comingAnimals.comingTableView.loadComingAnimals()
            
            let row = comingAnimals.comingTableView.comingAnimals.count
            cardHeight = cardHandleAreaHeight + CGFloat((90 * row))
            comingAnimals.view.frame = CGRect(x: comingAnimals.view.frame.origin.x, y: comingAnimals.view.frame.origin.y, width: comingAnimals.view.frame.size.width, height: cardHeight)
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.comingAnimals.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        let handle = comingAnimals.handleImg
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    handle?.transform = CGAffineTransform(rotationAngle: .pi)
                    self.comingAnimals.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    handle?.transform = CGAffineTransform(rotationAngle: .pi*2)
                    self.comingAnimals.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // MARK: - 데이터 배열 초기화
    func resetArray() {
        receiveAnimal = []
        imageUrls = []
        images = []
    }
    
    // MARK: - 동물 버튼 생성
    func makeButton(image: UIImage? = nil ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    // MARK: - 버튼 오토레이아웃 설정
    func locateButton(button: UIButton, left: Int, bottom: Int) {
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(left)).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(bottom)).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 465/348).isActive = true
    }
    
    // MARK: - 이미지 합성
    func compositeImage(images: [UIImage]) -> UIImage {
        var compositeImage: UIImage!
        if images.count > 0 {
            let size: CGSize = CGSize(width: images[0].size.width, height: images[0].size.height)
            UIGraphicsBeginImageContext(size)
            for image in images {
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                image.draw(in: rect)
            }
            compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return compositeImage
    }
    
    // MARK: - 동물 버튼 클릭 이벤트
    @objc func pressed1(_ sender: UIButton) {
        guard let confirmVC = self.storyboard?.instantiateViewController(identifier: "confirmVC") as? ConfirmLetter else {return}
        //confirmVC.modalPresentationStyle = .overFullScreen
        confirmVC.modalPresentationStyle = .overCurrentContext
        confirmVC.delegate = self
        confirmVC.randomId = receiveAnimal[0].id
//        let sub = UIStoryboard(name: "LetterListTab", bundle: nil)
//        guard let nextVC = sub.instantiateViewController(identifier: "ReplyPage") as? ReplyPage else {
//            return
//        }
//        nextVC.delegate = self
        self.present(confirmVC, animated: true, completion: nil)

    }
    
    @objc func pressed2(_ sender: UIButton) {
        guard let confirmVC = self.storyboard?.instantiateViewController(identifier: "confirmVC") as? ConfirmLetter else {return}
        confirmVC.modalPresentationStyle = .overCurrentContext
        confirmVC.delegate = self
        confirmVC.randomId = receiveAnimal[1].id
        self.present(confirmVC, animated: true, completion: nil)
    }
    
    @objc func pressed3(_ sender: UIButton) {
        guard let confirmVC = self.storyboard?.instantiateViewController(identifier: "confirmVC") as? ConfirmLetter else {return}
        confirmVC.modalPresentationStyle = .overCurrentContext
        confirmVC.delegate = self
        confirmVC.randomId = receiveAnimal[2].id
        self.present(confirmVC, animated: true, completion: nil)
    }
    
    @objc func pressed4(_ sender: UIButton) {
        guard let confirmVC = self.storyboard?.instantiateViewController(identifier: "confirmVC") as? ConfirmLetter else {return}
        confirmVC.modalPresentationStyle = .overCurrentContext
        confirmVC.delegate = self
        confirmVC.randomId = receiveAnimal[3].id
        self.present(confirmVC, animated: true, completion: nil)
    }
    @objc func pressed5(_ sender: UIButton) {
        guard let confirmVC = self.storyboard?.instantiateViewController(identifier: "confirmVC") as? ConfirmLetter else {return}
        confirmVC.modalPresentationStyle = .overCurrentContext
        confirmVC.delegate = self
        confirmVC.randomId = receiveAnimal[4].id
        self.present(confirmVC, animated: true, completion: nil)
    }
    
    // MARK: - 뷰 생성
    func makeView() {
        // 뷰 초기화
        for view in view.subviews where view is UIButton {
            view.removeFromSuperview()
        }
        
        if receiveAnimal.count == 0 {
            return
        } else if receiveAnimal.count == 1 {
            let button1 = makeButton(image: images[0])
            view.addSubview(button1)
            locateButton(button: button1, left: 100, bottom: -200)
            button1.addTarget(self, action: #selector(pressed1(_:)), for: .touchUpInside)
        } else if receiveAnimal.count == 2 {
            let button1 = makeButton(image: images[0])
            let button2 = makeButton(image: images[1])
            view.addSubview(button1)
            view.addSubview(button2)
            locateButton(button: button1, left: 40, bottom: -190)
            locateButton(button: button2, left: 260, bottom: -320)
            button1.addTarget(self, action: #selector(pressed1(_:)), for: .touchUpInside)
            button2.addTarget(self, action: #selector(pressed2(_:)), for: .touchUpInside)
        } else if receiveAnimal.count == 3 {
            let button1 = makeButton(image: images[0])
            let button2 = makeButton(image: images[1])
            let button3 = makeButton(image: images[2])
            view.addSubview(button1)
            view.addSubview(button2)
            view.addSubview(button3)
            locateButton(button: button1, left: 30, bottom: -350)
            locateButton(button: button2, left: 260, bottom: -130)
            locateButton(button: button3, left: 190, bottom: -340)
            button1.addTarget(self, action: #selector(pressed1(_:)), for: .touchUpInside)
            button2.addTarget(self, action: #selector(pressed2(_:)), for: .touchUpInside)
            button3.addTarget(self, action: #selector(pressed3(_:)), for: .touchUpInside)
        } else if receiveAnimal.count == 4 {
            let button1 = makeButton(image: images[0])
            let button2 = makeButton(image: images[1])
            let button3 = makeButton(image: images[2])
            let button4 = makeButton(image: images[3])
            view.addSubview(button1)
            view.addSubview(button2)
            view.addSubview(button3)
            view.addSubview(button4)
            locateButton(button: button1, left: 230, bottom: -180)
            locateButton(button: button2, left: 190, bottom: -250)
            locateButton(button: button3, left: 20, bottom: -200)
            locateButton(button: button4, left: 100, bottom: -350)
            button1.addTarget(self, action: #selector(pressed1(_:)), for: .touchUpInside)
            button2.addTarget(self, action: #selector(pressed2(_:)), for: .touchUpInside)
            button3.addTarget(self, action: #selector(pressed3(_:)), for: .touchUpInside)
            button4.addTarget(self, action: #selector(pressed4(_:)), for: .touchUpInside)
        } else {
            let button1 = makeButton(image: images[0])
            let button2 = makeButton(image: images[1])
            let button3 = makeButton(image: images[2])
            let button4 = makeButton(image: images[3])
            let button5 = makeButton(image: images[4])
            view.addSubview(button1)
            view.addSubview(button2)
            view.addSubview(button3)
            view.addSubview(button4)
            view.addSubview(button5)
            locateButton(button: button1, left: 30, bottom: -170)
            locateButton(button: button2, left: 160, bottom: -230)
            locateButton(button: button3, left: 200, bottom: -350)
            locateButton(button: button4, left: 300, bottom: -300)
            locateButton(button: button5, left: 40, bottom: -320)
            button1.addTarget(self, action: #selector(pressed1(_:)), for: .touchUpInside)
            button2.addTarget(self, action: #selector(pressed2(_:)), for: .touchUpInside)
            button3.addTarget(self, action: #selector(pressed3(_:)), for: .touchUpInside)
            button4.addTarget(self, action: #selector(pressed4(_:)), for: .touchUpInside)
            button5.addTarget(self, action: #selector(pressed5(_:)), for: .touchUpInside)
        }
    }
    // db 테스트용 아이디 6076f87f8df06a0080fca113, 6071ad3f4f29c9d6f5393307
    // MARK: - 데이터 수신 및 표출
    func refreshData() {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/letters/random", token: session.value) { [self] (data, response, error) in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        resetArray()
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let animal: [String: String] = [
                                "animal_url": json["post_animal"]["animal_url"].stringValue,
                                "head_url": json["post_animal"]["head_url"].stringValue,
                                "top_url": json["post_animal"]["top_url"].stringValue,
                                "pants_url": json["post_animal"]["pants_url"].stringValue,
                                "shoes_url": json["post_animal"]["shoes_url"].stringValue,
                                "gloves_url": json["post_animal"]["gloves_url"].stringValue]
                            self.receiveAnimal.append(RandomAnimal(id: json["_id"].stringValue, animal: animal))
                        }
                        // 이미지url 저장배열 생성 및 동물사진url 첫번쨰로 위치
                        if imageUrls.count != receiveAnimal.count {
                            // imageUrls = []
                            for i in 0..<receiveAnimal.count {
                                let sortedUrl = receiveAnimal[i].animal.sorted(by: <)
                                var temp: [String] = []
                                
                                for row in sortedUrl {
                                    temp.append(row.value)
                                }
                                imageUrls.append(temp)
                                temp = []
                            }
                        }
                        // url -> 이미지로 변환 후 합성 및 저장
                        for i in 0..<imageUrls.count {
                            var ingredImage: [UIImage] = []
                            for url in imageUrls[i] {
                                if let imageURL = URL(string: url) {
                                    if let imageData = try? Data(contentsOf: imageURL) {
                                        if let img = UIImage(data: imageData) {
                                            ingredImage.append(img)
                                        }
                                    }
                                }
                            }
                            images.append(compositeImage(images: ingredImage))
                            ingredImage = []
                        }
                        
                        // 뷰 생성
                        DispatchQueue.main.async {
                            makeView()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 모달화면 delegate 함수
extension MainPage: modalDelegate {
    func pushNavigation() {
        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") else {return}
        //self.present(writingVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(writingVC, animated: true)
    }
    
    func refresh() {
        resetArray()
        refreshData()
    }
}
