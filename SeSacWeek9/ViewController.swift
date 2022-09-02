//
//  ViewController.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/08/30.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var lottoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var viewModel = PersonViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let example = User("고래밥")
        
        example.bind { value in
            print("이름이 \(value)으로 바뀌었습니다.")
        }
        
        example.value = "칙촉"
        
        
        let sample = User([1, 2, 3, 4, 5])
        sample.bind { value in
            print(value.count)
        }
        
        
        var number1 = 10
        var number2 = 3
        
        print(number1 - number2)
        
        number1 = 3
        number2 = 1
        
        
        var number3 = Observable(10)
        var number4 = Observable(3)
        
        number3.bind { a in
            print("Observable", number3.value - number4.value)
        }
        
        number3.value = 100
        number3.value = 200
        number3.value = 50
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Lotto
//        LottoAPIManager.requestLotto(drwNo: 1011) { lotto, error in
//
//            guard let lotto = lotto else {
//                return
//            }
//
//            self.lottoLabel.text = lotto.drwNoDate
//        }
        
        
        // Person
        viewModel.fetchPerson(query: "kim")
        
        viewModel.list.bind { person in
            print("ViewController bind")
            self.tableView.reloadData()
        }
    }

}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let data = viewModel.cellForRowAt(at: indexPath)
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.knownForDepartment
        return cell
    }
}
