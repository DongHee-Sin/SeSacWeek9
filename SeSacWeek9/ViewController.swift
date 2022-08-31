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
