//
//  LoginViewController.swift
//  Messenger
//
//  Created by luca andrea mazzer on 10/05/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func validateFields () -> (valid: Bool, errorMessage: String) {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            return (false, "All field are required")
        }
        if( password.count < 6 ) {
            return (false, "password length should have  6 or more characters")
        }
        return (true, "")
    }

 
    func loginAttemp () {
        let validation = validateFields();
        if !validation.valid {
            errorMessage.text = validation.errorMessage
            return
        }
        if let email =  emailField.text, let password  =  passwordField.text {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil, let result = authResult else {
                    ErrorDialog(message: "Bad credentials")
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    @IBAction func loginAction(_ sender: Any) {
        loginAttemp()
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            loginAttemp()
        }
        return true
    }
}
