//
//  ViewController.swift
//  AroundHear
//
//  Created by Guillermo on 3/19/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuthUI


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func LoginButton(_ sender: UIButton) {
        
        //get the default auth UI object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        //set ourselves as the delegate
        authUI?.delegate = self as! FUIAuthDelegate
        //Get a reference to the auth UI view controller
        let authViewController = authUI!.authViewController()
        //show it
        present(authViewController, animated: true, completion: nil)
    }
}

extension ViewController: FUIAuthDelegate{
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        //check if there was an error
        
        if error != nil {
            return
        }
        //authDataResult?.user.uid
        performSegue(withIdentifier: "goHome", sender: self)
    }
}
