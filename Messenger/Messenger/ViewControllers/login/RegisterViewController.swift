//
//  RegisterViewController.swift
//  Messenger
//
//  Created by luca andrea mazzer on 10/05/2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var errorMessage: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = UIImage(systemName: "person.circle")
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profileImage.addGestureRecognizer(imageGesture)
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2.0
    }
    
    
    @objc private func didTapImage() {
        presentPhotoActionSheet()
    }
    
    
    func validateFields () -> (valid: Bool, errorMessage: String) {
        guard let email = emailField.text, let password = passwordField.text, let confirmPasword = confirmPasswordField.text, let name = nameField.text, let lastname = lastnameField.text, !name.isEmpty, !lastname.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPasword.isEmpty else {
            return (false, "All field are required")
        }
        if (password != confirmPasword ) {
            return (false, "password and confirm password should be equals")
        }
        if( password.count < 6 ) {
            return (false, "password length should have  6 or more characters")
        }
        return (true, "")
    }

 
    func registerAttemp () {
        let validation = validateFields();
        if !validation.valid {
            errorMessage.text = validation.errorMessage
            return
        }
       // Firebase register
        if let email = emailField.text, let password = passwordField.text {
            
            DBManager.share.userExist(with: email) { exist in
                guard !exist else {
                    self.ErrorDialog(message: "User already exist!")
                    return
                }
                    
                FirebaseAuth.Auth.auth().createUser(withEmail: email , password: password) { authResult, error in
                    
                    guard error == nil, authResult != nil else {
                        self.ErrorDialog(message: "Error creating user")
                        return
                    }
                    
                    DBManager.share.insertUser(with: ChatAppUser(firstName: self.nameField.text!, lastName: self.lastnameField.text!, email: email))
                    
                    
                    self.dismiss(animated: true, completion: nil)
                }
                            
            }
        }
    }

    @IBAction func registerAction(_ sender: Any) {
        registerAttemp()
    }


}

extension RegisterViewController: UITextFieldDelegate, UINavigationControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            lastnameField.becomeFirstResponder()
        }
        if textField == lastnameField {
            emailField.becomeFirstResponder()
        }
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        }
        if textField == confirmPasswordField {
            registerAttemp()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Choso Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet,animated: true)
    }
    
    func presentCamera() {
        let vc =  UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc =  UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profileImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
}
