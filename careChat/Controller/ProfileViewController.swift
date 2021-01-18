//
//  ProfileViewController.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import UIKit
import Firebase

class profileViewController: UIViewController {

    @IBOutlet weak var mailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        showUserInfo()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
      
    }
    
    func showUserInfo() {
        if let userMail = Auth.auth().currentUser?.email {
            mailLabel.text = "Signed in as: \(userMail)"
        }
    }


}
