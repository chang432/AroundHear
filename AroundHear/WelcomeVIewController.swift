//
//  WelcomeVIewController.swift
//  AroundHear
//
//  Created by Guillermo on 3/28/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import QuartzCore

class WelcomeVIewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = UIColor .orange
        view.setGradientBackground(colorOne: UIColor.init(red: 95/255.0, green: 114/255.0, blue: 189/255.0, alpha: 1.0), colorTwo: UIColor.init(red: 155/255.0, green: 35/255.0, blue: 234/255.0, alpha: 1.0))
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToRegister", sender: self)
        
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
