//
//  ProfileViewController.swift
//  AroundHear
//
//  Created by Andre Chang on 4/11/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(colorOne: UIColor.cyan, colorTwo: UIColor.lightGray)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        print("HELLO")
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in self.signOut()}))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func signOut()  {
        do {
            try Auth.auth().signOut()
            print("YOU ARE NOW SIGNED OUT")
            let main = UIStoryboard(name: "Main", bundle: nil)
            
            let loginViewController = main.instantiateViewController(withIdentifier: "welcomeScreen")
            
            //            let delegate = UIApplication.shared.delegate as! AppDelegate
            //            delegate.window?.rootViewController = loginViewController
            //            delegate.window?.makeKeyAndVisible()
            self.present(loginViewController, animated: true, completion: nil)
            
            
            
        }catch let error {
            print(error.localizedDescription)
            
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