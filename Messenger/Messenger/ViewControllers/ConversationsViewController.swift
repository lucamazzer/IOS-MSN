//
//  ViewController.swift
//  Messenger
//
//  Created by luca andrea mazzer on 10/05/2022.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateUserLogged()
    }
    
    private func validateUserLogged () {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginScreen")
            present(vc, animated: true, completion: nil)
        }
        
    }
}

