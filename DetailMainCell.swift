//
//  DetailMainCell.swift
//  metalgalaxy
//
//  Created by AugieD369 on 1/28/17.
//  Copyright © 2017 Aaron Erdman. All rights reserved.
//

import UIKit

class DetailMainCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}