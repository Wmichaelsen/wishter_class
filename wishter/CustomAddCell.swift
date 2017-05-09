//
//  CustomAddCell.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-03-08.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

protocol CustomAddCellDelegate {
    func imageButtonTapped(_ sender: Any)
    func textFieldEdited(_ textField: UITextField)
}

class CustomAddCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var URLField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    var delegate: CustomAddCellDelegate?
    
    @IBAction func imageTapped(_ sender: Any) {
        self.delegate?.imageButtonTapped(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleField.tag = 0
        priceField.tag = 1
        URLField.tag = 2
        
        titleField.delegate = self
        priceField.delegate = self
        URLField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldEdited(textField)
    }
    
    
}
