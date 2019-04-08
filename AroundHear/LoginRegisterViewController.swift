//
//  LoginRegisterViewController.swift
//  AroundHear
//
//  Created by Guillermo on 3/25/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase



class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var signInRegisterSelector: UISegmentedControl!
    @IBOutlet weak var signInRegisterLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInRegisterButton: UIButton!
    
    @IBOutlet weak var lengthIndicatorLabel: UILabel!
    
    
    var isSignIn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let content = emailTextField.text
        let first = content?.components(separatedBy: " ").first
        if first!.count > 6 {
            lengthIndicatorLabel.text = "ok lenght"
        }else{
            lengthIndicatorLabel.text = "lenght not ok"
        }
        //if emailTextField.text.leng
    }
   
    
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        //if user changed the selector we flip the value of isSignIn which indicates is the selector is in the Sign in option
        isSignIn = !isSignIn
        
        //check value of isSignIn to set the values of the labels
        if isSignIn{
            signInRegisterLabel.text = "Sign In"
            signInRegisterButton.setTitle("Sign In", for: .normal)
        }else{
            signInRegisterLabel.text = "Register"
            signInRegisterButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        //Need to do password and email validation
        
        if let email = emailTextField.text, let password = passwordTextField.text{
        //check value of isSignIn to know whether we are signing in or registering
            if isSignIn{
                //sign in the user
                Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                    //check if returned user is nil
                    if let u = user{
                        //correct password -> go to home screen
                        self.performSegue(withIdentifier: "goHome", sender: self)
                    }else{
                        //Error, check error and display message
                        let errorMessage = error?.localizedDescription
                        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                })
                    // ...
                
            } else{
                //Register the user in firebase
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    //check user was created successfully
                    if let u = user{
                        //correct registration -> go to home screen

                        Database.database().reference().child("users").child(u.user.uid).setValue(["email": email])
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
