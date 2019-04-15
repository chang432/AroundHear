//
//  playlistTableViewCell.swift
//  AroundHear
//
//  Created by Andre Chang on 4/14/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit

class playlistTableViewCell: UITableViewCell {

    @IBOutlet var playlistName: UILabel!
    @IBOutlet var tracknum: UILabel!
    @IBOutlet var playlistPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
