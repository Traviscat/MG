//
//  itemListCell.swift
//  metalgalaxy
//
//  Created by Aaron on 6/19/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemInfo1: UILabel!
    @IBOutlet weak var itemInfo2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
