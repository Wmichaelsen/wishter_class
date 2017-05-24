
//
//  CustomItemHeader.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 5/23/17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

protocol CustomItemHeaderDelegate {
    func buyTapped(_ sender: Any)
}

class CustomItemHeader: UICollectionReusableView {
        
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var delegate: CustomItemHeaderDelegate?
    
    @IBAction func buyTapped(_ sender: Any) {
        self.delegate?.buyTapped(sender)
    }
    
}
