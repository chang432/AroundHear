//
//  PlaylistTracksTableViewCell.swift
//  AroundHear
//
//  Created by Andre Chang on 4/19/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit

class PlaylistTracksTableViewCell: UITableViewCell {

    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var trackArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
