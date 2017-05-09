//
//  CustomUserCell.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-04-10.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class CustomUserCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
