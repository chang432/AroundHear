//
//  UsersCell.swift
//  AroundHear
//
//  Created by Guillermo on 4/11/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var bView: UIView!
    
    @IBOutlet weak var rView: UIView!
    //@IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let color = UIColor(red: 155/255.0, green: 35/255.0, blue: 234/255.0, alpha: 1)
        rView.layer.backgroundColor = color.cgColor
        let color2 = UIColor(red: 95/255.0, green: 114/255.0, blue: 189/255.0, alpha: 1)
        //self.backgroundColor = color2
        
        rView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
