//
//  LoginViewController.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/09/01.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel = LoginViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        
        
        viewModel.name.bind { [weak self] text in
            self?.nameTextField.text = text
        }
        
        viewModel.password.bind { [weak self] text in
            self?.passwordTextField.text = text
        }
        
        viewModel.email.bind { [weak self] text in
            self?.emailTextField.text = text
        }
        
        viewModel.isValid.bind { [weak self] bool in
            self?.loginButton.isEnabled = bool
            self?.loginButton.backgroundColor = bool ? .systemOrange : .lightGray
        }
    }
    
    
    @objc func nameTextFieldChanged(_ sender: UITextField) {
        viewModel.name.value = sender.text!
        viewModel.checkValidation()          // 텍스트가 입력될 때마다 조건이 맞는지 확인해달라고 부탁하는..!
    }
    
    @objc func passwordTextFieldChanged(_ sender: UITextField) {
        viewModel.password.value = sender.text!
        viewModel.checkValidation()
    }
    
    @objc func emailTextFieldChanged(_ sender: UITextField) {
        viewModel.email.value = sender.text!
        viewModel.checkValidation()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.signIn {
            // 조건처리나.. 뭐 그런건 ViewModel부분에서 다 처리하고, 기능적인 부분만 여기서 클로저로 정의
            // 화면 전환 코드
        }
    }
    
}
