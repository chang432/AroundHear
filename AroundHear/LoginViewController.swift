//
//  LoginViewController.swift
//  AroundHear
//
//  Created by Guillermo on 3/28/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor .orange
        logInButton.layer.cornerRadius = logInButton.frame.height/2
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWelcome", sender: self)
    }
    
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
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
