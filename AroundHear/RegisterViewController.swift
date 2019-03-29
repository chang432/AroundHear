//
//  RegisterViewController.swift
//  AroundHear
//
//  Created by Guillermo on 3/28/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTakenLabel: UILabel!
    
    var usernameistaken: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, usernameistaken == false {
        
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                //check user was created successfully
                if let u = user{
                    //correct registration -> go to home screen
                    Database.database().reference().child("users").child(u.uid).setValue(["email": email, "username": username])
                    self.performSegue(withIdentifier: "goHome", sender: self)
                    
                }else{
                    //an error ocured, chow message
                    let errorMessage = error?.localizedDescription
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: textField.text).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                self.usernameistaken = true
                self.usernameTakenLabel.text = "Sorry this username is taken"
                self.usernameTakenLabel.textColor = UIColor .red
                
            } else{
                self.usernameistaken = false
                self.usernameTakenLabel.text = "This username available"
                self.usernameTakenLabel.textColor = UIColor .green
            }
        }
        //if emailTextField.text.leng
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
