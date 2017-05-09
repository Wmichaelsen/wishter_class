//
//  ProfileViewController.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-04-12.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var myCollectionView: UICollectionView!
    var currentUser: FIRDataSnapshot?
    var currentUserWishes: NSMutableArray? = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        
        self.title = "Profile"
        
        /* Retrieve user wishes as NSDictionaries */
        WishManager.sharedInstance.getMyWishes(userID: self.currentUser?.key, completion: {
            (wish) in
            if wish != nil {
                
                if let newWish = wish {
                    if let newWishID = (wish?["wishData"] as? FIRDataSnapshot)?.key {
                        if !self.wishAlreadyExists(wishID: newWishID) {
                            self.currentUserWishes?.add(newWish)
                            self.myCollectionView.reloadData()
                        }
                    }
                }
                
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentUserWishes!.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! CustomProfileCell
        
        // Configure cell ...
        cell.wishTitle.text = (((self.currentUserWishes?.object(at: indexPath.row) as! NSDictionary)["wishData"]! as? FIRDataSnapshot)?.value as? NSDictionary)?["title"] as? String
        cell.wishPrice.text = (((self.currentUserWishes?.object(at: indexPath.row) as! NSDictionary)["wishData"]! as? FIRDataSnapshot)?.value as? NSDictionary)?["price"] as? String
        cell.wishImageView.image = (self.currentUserWishes?.object(at: indexPath.row) as! NSDictionary)["image"] as? UIImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableHeaderView: ProfileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViewID", for: indexPath) as! ProfileHeader
        
        reusableHeaderView.userImageView.layer.cornerRadius = reusableHeaderView.userImageView.frame.size.height / 2
        reusableHeaderView.userImageView.clipsToBounds = true
        
        reusableHeaderView.userImageView.sd_setImage(with: URL(string: ((currentUser?.value as! [String:AnyObject] as NSDictionary).object(forKey: "pictureURL") as? String)!))
        reusableHeaderView.userName.text = (currentUser?.value as! [String:AnyObject] as NSDictionary).object(forKey: "name")! as? String
        reusableHeaderView.userStatus.text = (currentUser?.value as! [String:AnyObject] as NSDictionary).object(forKey: "status")! as? String

        return reusableHeaderView
    }
    
    //MARK: Private helper methods
    private func wishAlreadyExists(wishID: String?) -> Bool {
        
        if self.currentUserWishes != nil && wishID != nil {
            
            /* Iterate over all existing interests */
            for existingWish in self.currentUserWishes! {
                if let existingWishID = ((existingWish as? NSDictionary)?["wishData"] as? FIRDataSnapshot)?.key {
                    if wishID! == existingWishID {
                        // Already exists: return true
                        return true
                    }
                }
            }
        } else {
            print("userWishes or passed interest is nil (ViewController.swift)")
        }
        
        /* Return false by default */
        return false
        
    }

}
