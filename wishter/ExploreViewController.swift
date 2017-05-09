//
//  ExploreViewController.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-04-10.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usersArray: NSMutableArray? = NSMutableArray()
    var clickedUser: FIRDataSnapshot?
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        
        // Retrieve users from Firebase. Already nil-checked
        WishManager.sharedInstance.getOtherUsers(completion: {
            (user) in
            self.usersArray?.add(user!)
            self.myTableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomUserCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! CustomUserCell
        
        // Configure the cell...
        let pictureURL = ((self.usersArray?.object(at: indexPath.row) as? FIRDataSnapshot)?.value as! [String:AnyObject] as NSDictionary).object(forKey: "pictureURL") as? String
        let name = ((self.usersArray?.object(at: indexPath.row) as? FIRDataSnapshot)?.value as! [String:AnyObject] as NSDictionary).object(forKey: "name") as? String
        let status = ((self.usersArray?.object(at: indexPath.row) as? FIRDataSnapshot)?.value as! [String:AnyObject] as NSDictionary).object(forKey: "status") as? String
        
        if pictureURL != nil && name != nil && status != nil {
            cell.userName.text = name!
            cell.userStatus.text = status!
            cell.userImageView.sd_setImage(with: URL(string: pictureURL!))
        } else {
            print("stuff are nil (ExploreViewController.swift)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickedUser = (self.usersArray?.object(at: indexPath.row) as! FIRDataSnapshot)
        
        self.performSegue(withIdentifier: "toProfile", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            (segue.destination as! ProfileViewController).currentUser = self.clickedUser
        }
    }
}
