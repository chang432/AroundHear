//
//  ChatScreenViewController.swift
//  AroundHear
//
//  Created by Guillermo on 4/21/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import Firebase


class ChatScreenViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var messageTextField: UITextField!
    var key: String!
    let ref = Database.database().reference().child("messages")
    @IBOutlet weak var nameBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self as! UITextFieldDelegate
        observeMessages()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendButtton(_ sender: Any) {
        handleSend()
        cleanTextBox()
        
    }
    
    
    func cleanTextBox(){
        messageTextField.text = ""
    }
    func handleSend(){
        
        
        let childRef = self.ref.childByAutoId()
        let destinationId = key!
        let sourceId = Auth.auth().currentUser!.uid
        let timeStamp = NSDate().timeIntervalSince1970
        let values = ["text": messageTextField.text!, "toId": destinationId, "fromId": sourceId, "timestamp": timeStamp] as [String : AnyObject]
        
        childRef.updateChildValues(values)
        
    }
    
    func observeMessages() {
        Database.database().reference().child("messages").observe(.childAdded, with: {(snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject]{
                let message = Message()
//                for item in dictionary{
//                    message.text = item
//                    print(message.text)
//                }
                print(snapshot)
//                message.setValuesForKeys(dictionary)
//                print(message.text)
            }

        }, withCancel: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
