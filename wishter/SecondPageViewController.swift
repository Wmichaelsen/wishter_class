//
//  Second PageViewController.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-08-22.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class SecondPageViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        for c in self.stackView.constraints {
            
            if c.identifier != nil {
                if c.identifier! == "viewWidth" {
                    
                    c.isActive = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 140)
                    
                    new.identifier = "viewWidth"
                    
                    new.isActive = true
                    
                } else if c.identifier! == "viewHeight" {
                    
                    c.isActive = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.height,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 148.5)
                    
                    new.identifier = "viewHeight"
                    
                    new.isActive = true
                    
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for c in self.stackView.constraints {
            
            if c.identifier != nil {
                if c.identifier! == "viewWidth" {
                    
                    c.isActive = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 280)
                    
                    new.identifier = "viewWidth"
                    
                    new.isActive = true
                    
                } else if c.identifier! == "viewHeight" {
                    
                    c.isActive = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.height,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 297)
                    
                    new.identifier = "viewHeight"
                    
                    new.isActive = true
                    
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    
    
}
