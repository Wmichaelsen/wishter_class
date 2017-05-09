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
    fileprivate let login: Login = Login()
    var lastContentXOffset: CGFloat = 0.0
    var x: CGFloat = 0.0
    
    override func viewDidLoad() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        self.loginButton.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    func loginTapped() {
        /* Does the actual login with UI */
        
        login.setFirebaseURL("https://wishter-f0c10.firebaseio.com/")
        login.setFBPermission(["email", "public_profile", "user_birthday", "read_custom_friendlists"])
        
        login.loginFromViewController(self, completion: {
            (firebaseError, facebookError, authData) in
            if firebaseError != nil {
                print("Firebase error: \(firebaseError!)")
            } else if facebookError != nil {
                print("Facebook error: \(facebookError!)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let introPageViewController = segue.destination as? IntroPageViewController {
            introPageViewController.customDelegate = self
        }
    }
}

extension IntroViewController: IntroPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController, didScroll: UIScrollView) {
        
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
        self.bgImageView.frame = CGRect(x: -self.x, y: 0, width: self.bgImageView.frame.size.width, height: self.bgImageView.frame.size.height)

        self.lastContentXOffset = didScroll.contentOffset.x
        
        
//        print("\n\nDIFF: \(self.lastContentXOffset-didScroll.contentOffset.x)")
//        print("last: \(self.lastContentXOffset)")
//        print("scroll: \(didScroll.contentOffset.x)")
//        print("x: \(x)")
//        print("bg: \(self.bgImageView.frame.origin.x)")
    }
    
}
