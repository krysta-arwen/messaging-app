//
//  LogInViewController.swift
//  MessagesTask
//
//  Created by Krysta Deluca on 7/5/18.
//  Copyright © 2018 Krysta Deluca. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logInTapped(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text, email.characters.count > 0, password.characters.count > 0 else {
            self.showAlert(message: "Enter an email and a password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.userNotFound.rawValue {
                    self.showAlert(message: "There are no users with the specified account.")
                } else if error._code == AuthErrorCode.wrongPassword.rawValue {
                    self.showAlert(message: "Incorrect username or password.")
                } else {
                    self.showAlert(message: "Error: \(error.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            
            if let user = Auth.auth().currentUser {
                AuthenticationManager.sharedInstance.didLogIn(user: user)
                self.performSegue(withIdentifier: "ShowMessagesFromLogin", sender: nil)
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "iChat", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
