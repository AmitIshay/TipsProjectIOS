//
//  CreateAccountViewController.swift
//  TipMaster
//
//  Created by Student14 on 12/08/2024.
//

import UIKit
import Firebase


class CreateAccountViewController: UIViewController{
    
    
    @IBOutlet weak var emailTextFiled: UITextField!
    
    @IBOutlet weak var passwordTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signupClicked(_ sender: Any) {
        guard let email = emailTextFiled.text else { return}
        guard let password = passwordTextFiled.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { FirebaseResult, error in
            if let e = error{
                // something go rong
                self.showAlert(with: "Signin Failed", message: e.localizedDescription)
                
            }
            else{
                //go to home screen
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
