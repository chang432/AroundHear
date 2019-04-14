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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
