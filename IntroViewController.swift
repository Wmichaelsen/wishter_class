//
//  IntroViewController.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-07-19.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIView!
    private let login: Login = Login()
    var lastContentXOffset: CGFloat = 0.0
    var x: CGFloat = 0.0
    
    override func viewDidLoad() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        self.loginButton.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    func loginTapped() {
        /* Does the actual login with UI */
        
        login.setFirebaseURL("https://sizzling-heat-9137.firebaseio.com/")
        login.setFBPermission(["email", "public_profile", "user_birthday"])
        
        login.loginFromViewController(self, completion: {
            (firebaseError, facebookError, authData) in
            if firebaseError != nil {
                print("Firebase error: \(firebaseError!)")
            } else if facebookError != nil {
                print("Facebook error: \(facebookError!)")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let introPageViewController = segue.destinationViewController as? IntroPageViewController {
            introPageViewController.customDelegate = self
        }
    }
}

extension IntroViewController: IntroPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: IntroPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: IntroPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    func tutorialPageViewController(tutorialPageViewController: IntroPageViewController, didScroll: UIScrollView) {
        
        if self.lastContentXOffset > didScroll.contentOffset.x {
            // RIGHT
            if x > 0 {
                x -= 1
            }
            
        } else if self.lastContentXOffset < didScroll.contentOffset.x{
            // LEFT
            if x < 325 {
                x += 1
            }
        } else {
            x += 0
        }
        self.bgImageView.frame = CGRectMake(-self.x, 0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)

        self.lastContentXOffset = didScroll.contentOffset.x
        
        
//        print("\n\nDIFF: \(self.lastContentXOffset-didScroll.contentOffset.x)")
//        print("last: \(self.lastContentXOffset)")
//        print("scroll: \(didScroll.contentOffset.x)")
//        print("x: \(x)")
//        print("bg: \(self.bgImageView.frame.origin.x)")
    }
    
}