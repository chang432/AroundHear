//
//  ChatScreenViewController.swift
//  AroundHear
//
//  Created by Guillermo on 4/21/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import Firebase


class ChatScreenViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var messageTextField: UITextField!
    var key: String!
    let ref = Database.database().reference().child("messages")
    var messages = [Message]()
    var TableView: UITableView!
    
    
    
    @IBOutlet weak var nameBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.TableView.dataSource = self
//        self.TableView.delegate = self
        
    
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
                for (key,value) in dictionary{
                    if key == "text"{
                        message.text = value as? String
                    } else if key == "fromId" {
                        message.fromId = value as? String
                    } else if key == "toId"{
                        message.toId = value as? String
                    } else {
                        message.timestamp = value
                    }
                    self.messages.append(message)
                }
                
                print(message.fromId)
                print(message.text)
                print(message.timestamp)
                print(message.toId)
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        return cell
    }

}
