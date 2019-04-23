//
//  UserDetailsViewController.swift
//  AroundHear
//
//  Created by Guillermo on 4/21/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet var song: UIButton!
    
    @IBOutlet weak var nameBar: UINavigationItem!
    var key: String!
    var songURI: String!
    var songTitle: String!
    var songArtist: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        song.titleLabel?.text = songTitle
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let button = sender as! UIButton

        //let indexPath = tableView.indexPath(for: cell)!
        //Pass the selected movie to the details view controller
        let name = nameBar.title
        let detailsViewController = segue.destination as! ChatScreenViewController
        detailsViewController.nameBar.title = name
        detailsViewController.key = key
        
    }
 

}
