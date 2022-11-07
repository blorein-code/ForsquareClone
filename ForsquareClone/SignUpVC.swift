//
//  ViewController.swift
//  ForsquareClone
//
//  Created by Berke Topcu on 6.11.2022.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    @IBOutlet weak var userNameLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    

    @IBAction func signInClicked(_ sender: Any) {
        
        if userNameLabel.text != "" && passwordLabel.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameLabel.text!, password: passwordLabel.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                } else{
                    // Segue
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username // Password??")
        }
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        if userNameLabel.text != "" && passwordLabel.text != "" {
            
            let user = PFUser()
            user.username = userNameLabel.text!
            user.password = passwordLabel.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                } else{
                    //Segue yapılacak. Çünkü kullanıcı oluşturuldu.
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
    }
    
    func makeAlert(titleInput:String,messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}

