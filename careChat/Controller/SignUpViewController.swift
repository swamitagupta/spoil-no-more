//
//  SignUpViewController.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if nameTextField.text == "" {
            showAlert(message: "Enter your name.")
            
        } else {
            if let email = emailTextField.text, let password = passwordTextField.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        self.showAlert(message: e.localizedDescription)
                        
                    } else {
                        self.saveUserInfo()
                        self.performSegue(withIdentifier: "signUpToChatList", sender: self)
                        
                    }
                }
            }
        }
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func saveUserInfo() {
        if let name = nameTextField.text, let email = emailTextField.text {
            db.collection("users").addDocument(data: [
                "name" : name,
                "email": email
                
            ]) { (error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    //print("Successfully saved data")
                }
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //do nothing
          })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
