//
//  LoginViewController.swift
//  TipMaster
//
//  Created by Student14 on 12/08/2024.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

 
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
              showAlert(with: "Missing Information", message: "Please enter your email address.")
              return
          }
          
          guard let password = passwordTextField.text, !password.isEmpty else {
              showAlert(with: "Missing Information", message: "Please enter your password.")
              return
          }
          
          Auth.auth().signIn(withEmail: email, password: password) { FirebaseResult, error in
              if let e = error {
                  self.showAlert(with: "Login Failed", message: e.localizedDescription)
              } else {
                  // Go to home screen
                  self.performSegue(withIdentifier: "goToNext", sender: self)
              }
          }
        
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Change the message color to light blue
        let messageFont = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        let attributedMessage = NSAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
