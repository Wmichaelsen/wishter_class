//
//  IntroPageViewController.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-07-19.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

import Foundation
import UIKit

class IntroPageViewController: UIPageViewController, UIScrollViewDelegate {

    weak var customDelegate: IntroPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Find ScrollView */
        for v in self.view.subviews {
            
            if v.isKind(of: UIScrollView.self) {
                
                (v as? UIScrollView)?.delegate = self
            }
        }
        
        
        dataSource = self
        delegate = self
        
       
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.customDelegate?.tutorialPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
        
    }
    
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("1"),
                self.newColoredViewController("2"),
                self.newColoredViewController("3")]
    }()
    
    fileprivate func newColoredViewController(_ pageNumber: String) -> UIViewController {
        return UIStoryboard(name: "Guide", bundle: nil).instantiateViewController(withIdentifier: "page\(pageNumber)")
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.customDelegate?.tutorialPageViewController(self, didScroll: scrollView)
    }
}

extension IntroPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
        
    }
}


extension IntroPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first, let index = orderedViewControllers.index(of: firstViewController) {
            customDelegate?.tutorialPageViewController(self, didUpdatePageIndex: index)
        }
    }
}

protocol IntroPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController, didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController, didUpdatePageIndex index: Int)
    
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController, didScroll scrollView: UIScrollView)
    
}




