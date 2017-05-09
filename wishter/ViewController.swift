//
//  ViewController.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2016-12-15.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

/*
 
 THIS VIEWCONTROLLER PRESENTS THE PROFILE PAGE OF THE APP. IT ONLY HANDLES VIEW RELATED TASKS, AND OURSOURCES ALL DATA HANDLING ETC TO HELPER CLASSES AND APIs
 
 */


import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomAddCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var uid: String = WishManager.sharedInstance.uid!
    
    private let ADD_CELL_HEIGHT = 394.0
    
    private var addCellHeight = 0.0
    
    @IBOutlet weak var myTableView: UITableView!

    let picker = UIImagePickerController()
    
    let login: Login = Login()

    var wishImage: UIImage?
    
    var addWishTitleText: String? = ""
    var addWishPriceText: String? = ""
    var addWishURLText: String? = ""
    
    var userWishes: NSMutableArray? = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self

        self.picker.delegate = self
        
        self.title = "Profile"
        
        WishManager.sharedInstance.userAuthStatusWithBlock(completion: {
            (authData) in
            
            if authData != nil {
                // User is logged in
                
                self.uid = authData!.uid
                
                /* Find user data */
                WishManager.sharedInstance.readDataAtPath(path: "/users/\(self.uid)", eventType: .value, completion: {
                    (data) in
                    
                    if data?.value is NSNull {
                        // No profile exists: Create Profile
                        
                        /* Create user with data from Facebook */
                        UserCreator()
                        
                    } else {
                        // Profile exists: Populate profile page
                        
                        WishManager.sharedInstance.getFacebookFriends(completion: {
                            (result) in
                            
                            print("\n\n\(result)\n\n")
                        })

                        /* Fetch user wishes and update UI tableview. Retrived as NSDictionary ["wishData":data,"image":image] */
                        WishManager.sharedInstance.getMyWishes(userID: self.uid, completion: {
                            (wish) in
                            
                            if let newWish = wish {
                                print("\n\nNEWWISH:\n\(newWish)")
                                if let newWishID = (wish?["wishData"] as? FIRDataSnapshot)?.key {
                                    if !self.wishAlreadyExists(wishID: newWishID) {
                                        self.userWishes?.add(newWish)
                                        self.myTableView.reloadData()
                                    }
                                }
                            }
                        })
                        
                        /* Listen for removed wishes and update UI tableview */
                        WishManager.sharedInstance.readDataAtPath(path: "/users/\(self.uid)/wishes", eventType: .childRemoved, completion: {
                            (deletedWish) in
                            
                            if let newDeletedWishID = deletedWish?.key {
                                for wish in self.userWishes! {
                                    if (wish as? FIRDataSnapshot)?.key == newDeletedWishID {
                                        self.userWishes?.remove(wish)
                                        self.myTableView.reloadData()
                                    }
                                }
                            }
                            
                        })
                        
                        
//                        self.userWishes = (data?.value as! [String:AnyObject])["wishes"] as! [String:AnyObject] as NSDictionary
//                        print(self.userWishes!.allValues)
                    }
                })
            } else {
                // User is NOT logged in - present login UI
                
                /* Shows guide with login prompt */
                let storyboard = UIStoryboard(name: "Guide", bundle: nil)
                self.present(storyboard.instantiateInitialViewController()!, animated: true, completion: nil);
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions
    
    @IBAction func addWishTapped(_ sender: Any) {
        
        if self.navigationItem.rightBarButtonItem?.title == "Add" {
            // Into add-mode
            
            self.navigationItem.rightBarButtonItem?.title = "Done"
            
            self.myTableView.reloadData()
            
            addCellHeight = ADD_CELL_HEIGHT
            self.myTableView.beginUpdates()
            self.myTableView.endUpdates()
            
            self.title = "Add Wish"
        } else {
            // Into normal-mode
            
            self.navigationItem.rightBarButtonItem?.title = "Add"
            
            self.myTableView.reloadData()
            
            addCellHeight = 0.0
            self.myTableView.beginUpdates()
            self.myTableView.endUpdates()
            
            
            /* Update Firebase */
            if self.addWishTitleText != nil && self.wishImage != nil {
                
                /* Upload image and fetch unique path to store in the database entry */
                let imagePath = WishManager.sharedInstance.addWishImageToUser(image: self.wishImage!, user: self.uid)
                
                WishManager.sharedInstance.addWishTo(user: self.uid, wishDictionary: ["title" : self.addWishTitleText!, "price" : self.addWishPriceText!, "url" : self.addWishURLText!, "imagePath" : imagePath])
            } else {
                print("Title or wishImage is nil (viewController.swift)")
            }
            
            self.wishImage = nil
            
            /* Reset local text field storage */
            self.addWishTitleText = ""
            self.addWishPriceText = ""
            self.addWishURLText = ""
            
            self.title = "Profile"
        }
    }


    //MARK: UITableViewDelegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userWishes != nil {
            return self.userWishes!.count+1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if self.navigationItem.rightBarButtonItem?.title == "Done" {
            if indexPath.row == 0 {
                return CGFloat(addCellHeight)
            } else {
                return CGFloat(95.0)
            }
        } else {
            if indexPath.row == 0 {
                return CGFloat(addCellHeight)
            } else {
                return CGFloat(95.0)
            }
        }
    }
    
    /* Animate cells */
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        /* If in Add mode or not */
//        if self.navigationItem.rightBarButtonItem?.title == "Done" {
//            
//            /* Animate Add cell */
//            if indexPath.row == 0 {
//                
//                /* Initial Stage */
//                cell.alpha = 0.0
//                
//                /* Animate to following property values */
//                UIView.animate(withDuration: 1.0, animations: {
//                    cell.alpha = 1.0
//                })
//                
//            } else {
//                
//            }
//            
//        } else {
//        
//        }
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.navigationItem.rightBarButtonItem?.title == "Done" {
            // TableView loads in add-mode
            
            
            if indexPath.row == 0 {
                // Add-Cell
                
                let cell: CustomAddCell = self.myTableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! CustomAddCell
                cell.delegate = self
                
                /* If image is selected, update UI */
                if let image = wishImage {
                    cell.imageButton.setBackgroundImage(image, for: .normal)
                    cell.imageButton.setTitle("", for: .normal)
                }
                
                cell.isHidden = false
                return cell
            } else {
                // Wish-Cell
                    
                let cell: CustomWishCell = self.myTableView.dequeueReusableCell(withIdentifier: "CellID2", for: indexPath) as! CustomWishCell
                
                return cell
            }
        } else {
            // TableView loads in normal-mode
            
            if indexPath.row == 0 {
                // Add-Cell
                
                let cell: CustomAddCell = self.myTableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! CustomAddCell
                cell.delegate = self
                
                /* Update cell UI */
                
                cell.imageButton.setBackgroundImage(nil, for: .normal)
                cell.imageButton.setTitle("Image", for: .normal)
                
                cell.titleField.text = ""
                cell.priceField.text = ""
                cell.URLField.text = ""
                
                cell.isHidden = false
                
                return cell
            } else {
                // Wish-Cell
                
                let cell: CustomWishCell = self.myTableView.dequeueReusableCell(withIdentifier: "CellID2", for: indexPath) as! CustomWishCell
                
                /* Populate cell with wish fetched from Firebase, stored in userWishes (array) */
                cell.titleLabel.text = (((self.userWishes?.object(at: indexPath.row-1) as! NSDictionary)["wishData"]! as? FIRDataSnapshot)?.value as? NSDictionary)?["title"] as? String
                cell.priceLabel.text = "\(((((self.userWishes?.object(at: indexPath.row-1) as! NSDictionary)["wishData"]! as? FIRDataSnapshot)?.value as? NSDictionary)?["price"] as? String)!) USD"
                cell.linkLabel.text = (((self.userWishes?.object(at: indexPath.row-1) as! NSDictionary)["wishData"]! as? FIRDataSnapshot)?.value as? NSDictionary)?["url"] as? String
                cell.imgView.image = (self.userWishes?.object(at: indexPath.row-1) as! NSDictionary)["image"] as? UIImage
                                
                return cell
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.view.endEditing(true)
        }
    }
    
    //MARK: CustomAddCellDelegate
    func imageButtonTapped(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    /* Triggered everytime text is changed in any of the textfield */
    func textFieldEdited(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.addWishTitleText = textField.text
        case 1:
            self.addWishPriceText = textField.text
        case 2:
            self.addWishURLText = textField.text
        default:
            print("textField.tag error (ViewController.swift)")
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Saves selected image to be presented in addCell */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.wishImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.myTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private helper methods
    private func wishAlreadyExists(wishID: String?) -> Bool {
        
        if self.userWishes != nil && wishID != nil {
            
            /* Iterate over all existing interests */
            for existingWish in self.userWishes! {
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
