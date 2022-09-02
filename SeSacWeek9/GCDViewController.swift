//
//  GCDViewController.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit

class GCDViewController: UIViewController {
    
    // MARK: - 사이즈 큰 이미지 URL
    let url1 = URL(string: "https://apod.nasa.gov/apod/image/2201/OrionStarFree3_Harbison_5000.jpg")!
    let url2 = URL(string: "https://apod.nasa.gov/apod/image/2112/M3Leonard_Bartlett_3843.jpg")!
    let url3 = URL(string: "https://apod.nasa.gov/apod/image/2112/LeonardMeteor_Poole_2250.jpg")!
    
    
    @IBOutlet private weak var imageFirst: UIImageView!
    @IBOutlet private weak var imageSecond: UIImageView!
    @IBOutlet private weak var imageThird: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Serial Sync
    @IBAction func serialSync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        for i in 1...100 {
            print(i, terminator: " ")
        }
        
        //DispatchQueue.main.sync {    => 서로의 작업이 끝나는 것을 기다림 (무한대기 / 교착상태)
        for i in 101...200 {
            print(i, terminator: " ")
        }
        //}
        
        print("END")
    }
    
    
    
    // MARK: - Serial Async
    @IBAction func serialAsync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        //        DispatchQueue.main.async {
        //            for i in 1...100 {
        //                print(i, terminator: " ")
        //            }
        //        }
        
        for i in 1...100 {
            DispatchQueue.main.async {
                // 각 작업을 순서대로 Queue로 보내고, SerialQueue는 할당된 작업을 순서대로 실행하기 때문에 위 코드와 실행 결과에 차이가 없음
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
    }
    
    
    
    // MARK: - Global Sync
    @IBAction func globalSync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        DispatchQueue.global().sync {
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
    }
    
    
    
    // MARK: - Global Async
    @IBAction func globalAsync(_ sender: UIButton) {
        print("START  \(Thread.isMainThread)", terminator: " ")
        
        //        DispatchQueue.global().async {
        //            for i in 1...100 {
        //                print(i, terminator: " ")
        //            }
        //        }
        
        for i in 1...100 {
            DispatchQueue.global().async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END  \(Thread.isMainThread)")
    }
    
    
    
    // MARK: - GCD - QoS
    @IBAction func gcdQoS(_ sender: UIButton) {
        
        let customQueue = DispatchQueue(label: "concurrentSeSac", qos: .userInteractive, attributes: .concurrent)
        
        customQueue.async {
            print("START")
        }
        
        for i in 1...100 {
            DispatchQueue.global(qos: .background).async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            DispatchQueue.global(qos: .userInteractive).async {
                print(i, terminator: " ")
            }
        }
        
        for i in 201...300 {
            DispatchQueue.global(qos: .utility).async {
                print(i, terminator: " ")
            }
        }
    }
    
    
    
    // MARK: - Dispatch Group
    @IBAction func dispatchGroub(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            for i in 101...200 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            for i in 201...300 {
                print(i, terminator: " ")
            }
        }
        
        group.notify(queue: .main) {
            print("END")   // tableView.reload
        }
    }
    
    
    
    // MARK: - Dispatch Group NASA Image
    @IBAction func dispatchGroupNASA(_ sender: UIButton) {
//        request(url: url1) { image in
//            print("1")
//            self.request(url: self.url2) { image in
//                print("2")
//                self.request(url: self.url3) { image in
//                    print("3")
//
//                    print("끝. UI갱신.")
//                }
//            }
//        }
        
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url1) { image in
                print("1")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url2) { image in
                print("2")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url3) { image in
                print("3")
            }
        }
        
        group.notify(queue: .main) {
            print("끝. UI갱신.")
        }
        
    }
    
    
    func request(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(UIImage(systemName: "star"))
                return
            }
            
            let image = UIImage(data: data)
            completionHandler(image)
            
        }.resume()
    }
    
    
    
    // MARK: - Dispatch Group Enter Leave
    @IBAction func enterLeave(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var imageList: [UIImage?] = []
        
        group.enter()
        request(url: url1) { image in
            print("1")
            imageList.append(image)
            group.leave()
        }
        
        group.enter()
        request(url: url2) { image in
            print("2")
            imageList.append(image)
            group.leave()
        }
        
        group.enter()
        request(url: url3) { image in
            print("3")
            imageList.append(image)
            group.leave()
        }
        
        
        group.notify(queue: .main) {
            self.imageFirst.image = imageList[0]
            self.imageSecond.image = imageList[1]
            self.imageThird.image = imageList[2]
            print("끝. 완료.")
        }
    }
    
    
    
    // MARK: - Race Condition
    @IBAction func raceCondition(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var nickname = "SeSac"
        
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            nickname = "고래밥"
            print("first: \(nickname)")
        }
        
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            nickname = "칙촉"
            print("second: \(nickname)")
        }
        
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            nickname = "올라프"
            print("third: \(nickname)")
        }
        
        group.notify(queue: .main) {
            print("result: \(nickname)")
        }
        
    }
    
}

