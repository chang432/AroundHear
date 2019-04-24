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
    //var messages: Array<Message> = Array<Message>()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor .white
    
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
        
        var chatids = [String]()
        let messageId = childRef.key
        let child1 = sourceId+destinationId
        chatids.append(child1)
        let child2 = destinationId+sourceId
        chatids.append(child2)
        chatids.sort()
        
        
        let userMessageRef = Database.database().reference().child("user-messages")
        userMessageRef.child(chatids[0]).childByAutoId().updateChildValues(values)
        //userMessageRef.child(destinationId).updateChildValues([messageId!: 1])
        }
    
    func observeMessages() {
        
        let destinationId = key!
        let sourceId = Auth.auth().currentUser!.uid
        
        var chatids = [String]()
        let child1 = sourceId+destinationId
        chatids.append(child1)
        let child2 = destinationId+sourceId
        chatids.append(child2)
        chatids.sort()
        
        Database.database().reference().child("user-messages").child(chatids[0]).observe(.childAdded, with: {(snapshot) in
            
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
                        message.timestamp = value as? Double
                    }
                }
                self.messages.append(message)
            }
            
            
            DispatchQueue.main.async {
                self.messages.sort(by: { (Message1, Message2) -> Bool in
                    return (Message1.timestamp as! Double) < (Message2.timestamp as! Double)
                })
                self.tableView.reloadData()
            }
            //print(self.messages.text)
        }, withCancel: nil)
        

        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        
        let currentuserid = Auth.auth().currentUser!.uid
      
        if messages[indexPath.row].fromId == currentuserid{
            
            cell.myMessageLabel.text = messages[indexPath.row].text
            cell.myMessageLabel.layer.cornerRadius = 7
            cell.myMessageLabel.layer.masksToBounds = true
            
        } else if messages[indexPath.row].toId == currentuserid {
            cell.theirMessageLabel.text = messages[indexPath.row].text
            cell.theirMessageLabel.layer.cornerRadius = 7
            cell.theirMessageLabel.layer.masksToBounds = true
        }

        return cell
    }
    

}
