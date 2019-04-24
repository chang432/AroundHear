//
//  UserDetailsViewController.swift
//  AroundHear
//
//  Created by Guillermo on 4/21/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import Firebase

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet var track: UIButton!
    
    @IBOutlet weak var nameBar: UINavigationItem!
    var key: String!
    var songURI: String!
    var songTitle: String!
    var songArtist: String!
    var songImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
            self.profileName.text = self.nameBar.title
        
    Database.database().reference().child("users").child(key).child("song").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
        
            self.songTitle = value?["track_name"] as? String
            self.songArtist = value?["track_artist"] as? String
            self.songURI = value?["track_uri"] as? String
            var songImageURL = value?["track_image"] as? String
    
            if let mainImageURL =  URL(string: songImageURL!) {
                let mainImageData = NSData(contentsOf: mainImageURL)
                let mainImage = UIImage(data: mainImageData as! Data)
                self.songImage = mainImage
            }
        
            let songTitleArtist = self.songTitle
            self.track.setTitle(songTitleArtist, for: .normal)
        }, withCancel: nil)
    

        //track.setTitle(songTitle, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func songBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "otherUserSongIdentifier", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "otherUserSongIdentifier") {
            let vc = segue.destination as! OtherUserSongViewController
            vc.songTtle = self.songTitle
            vc.songURI = self.songURI
            vc.songImg = self.songImage
        } else {
            let button = sender as! UIButton

            //let indexPath = tableView.indexPath(for: cell)!
            //Pass the selected movie to the details view controller
            let name = nameBar.title
            let detailsViewController = segue.destination as! ChatScreenViewController
            detailsViewController.nameBar.title = name
            detailsViewController.key = key
        }
        
    }
 

}
