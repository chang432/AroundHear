//
//  ProfileViewController.swift
//  AroundHear
//
//  Created by Andre Chang on 4/11/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        
        
        /*var url : String = "https://api.spotify.com/v1/me/top/artists"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url)! as URL
        request.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                // process jsonResult
            } else {
                // couldn't load JSON, look at error
            }
            
            
        })*/



        
        let ref = Database.database().reference()
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? "Uknown User"
            
        self.profileName.text = username
        })
        
        
        
        super.viewDidLoad()

        view.setGradientBackground(colorOne: UIColor.cyan, colorTwo: UIColor.lightGray)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var currSongnName: UILabel!
    
    
    
    
    
    
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
