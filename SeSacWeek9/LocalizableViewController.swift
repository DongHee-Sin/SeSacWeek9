//
//  LocalizableViewController.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit
import MessageUI   // 1. 메일로 문의 보내기, 2. 디바이스에서 테스트, 3. 아이폰 메일 계정을 등록 해야 가능


class LocalizableViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sampleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "navigation_title".localized
        
        // 아래 코드에서 "고래밥"은 매개변수
        myLabel.text = "introduce".localized(with: "고래밥")
        
        inputTextField.text = "number_test".localized(number: 11)
        
        searchBar.placeholder = "search_placeholder".localized
        
        inputTextField.placeholder = "main_age_placeholder".localized
        
        let buttonTitle = "common_cancel".localized
        sampleButton.setTitle(buttonTitle, for: .normal)
    }
    
    
    func sendMail() {
        
        if MFMailComposeViewController.canSendMail() {
            // 메일 보내기
            let mail = MFMailComposeViewController()
            
            // 수신자 설정(?) 메일을 앱 사용자가 보낸건지 확인하기 위한..?
            mail.setToRecipients(["dong@naver.com"])
            
            // 제목 설정
            mail.setSubject("고래밥 다이어리 문의사항 --")
            
            // Delegate 설정도 가능
            mail.mailComposeDelegate = self
            
            self.present(mail, animated: true)
            

        }else {
            // alert. 메일 등록을 해주시거나, "dong@naver.com"으로 문의주세요
            print("ALERT")
        }
        
    }
    
}



// MARK: - Mail Protocol
extension LocalizableViewController: MFMailComposeViewControllerDelegate {
    
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//
//        switch result {
//        case .cancelled:
//            //
//        case .saved:
//            //
//        case .sent:
//            //
//        case .failed:
//            //
//        }
//
//        controller.dismiss(animated: true)
//
//    }
    
}






// MARK: - String + Extension
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
}
