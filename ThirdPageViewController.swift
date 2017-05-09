//
//  ThirdPageViewController.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-08-22.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class ThirdPageViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        for c in self.stackView.constraints {
            
            if c.identifier != nil {
                if c.identifier! == "viewWidth" {
                    
                    c.active = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.Width,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.NotAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 140)
                    
                    new.identifier = "viewWidth"
                    
                    new.active = true
                    
                } else if c.identifier! == "viewHeight" {
                    
                    c.active = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.Height,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.NotAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 118.5)
                    
                    new.identifier = "viewHeight"
                    
                    new.active = true
                    
                }
            }
            
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        for c in self.stackView.constraints {
            
            if c.identifier != nil {
                if c.identifier! == "viewWidth" {
                    
                    c.active = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.Width,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.NotAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 280)
                    
                    new.identifier = "viewWidth"
                    
                    new.active = true
                    
                } else if c.identifier! == "viewHeight" {
                    
                    c.active = false
                    
                    let new = NSLayoutConstraint(item: self.stackView,
                                                 attribute: NSLayoutAttribute.Height,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.NotAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 237)
                    
                    new.identifier = "viewHeight"
                    
                    new.active = true
                    
                }
            }
            
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    
    
}
