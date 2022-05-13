//
//  viewController.swift
//  Messenger
//
//  Created by luca andrea mazzer on 13/05/2022.
//

import Foundation
import UIKit


extension UIViewController {
    func ErrorDialog(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
}
