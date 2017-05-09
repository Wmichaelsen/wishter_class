//
//  CustomWishCell.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-02-02.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class CustomWishCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
