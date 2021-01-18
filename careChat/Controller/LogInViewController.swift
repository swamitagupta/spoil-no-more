//
//  LogInViewController.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showAlert(message: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "logInToChatList", sender: self)
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
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

