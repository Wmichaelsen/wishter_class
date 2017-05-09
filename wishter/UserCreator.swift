//
//  UserCreator.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-07-13.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.


/*
*       THIS CLASS CREATES USERS ONLY. THE ACTUAL WRITING TO FIREBASE HAPPENS IN CreateProfile.swift
*/

import Foundation
import UIKit


struct UserCreator {
    
    var name: String?
    var age: Int?
    var interests: [String]?
    var picture: String?
    var status: String?
    
    /* Use this method to create user with specific data */
    init(withName name: String?, age: Int?, interests: [String]?, picture: String?, agePreference: [Int]?, distacePreference: Int?, status: String?) {
        
        self.name = name
        self.age = age
        self.interests = interests
        self.picture = picture
        self.status = status
    }
    
    /* Use this method to create user with data from Facebook */
    init() {
        
        WishManager.sharedInstance.getFacebookProfileDetails(completion: {
            (profileDetails) in
            
            if profileDetails != nil {
                
                /* Gather all data and create profile */
                let name = profileDetails!["name"]?.object(forKey: "name") as? String
                let age = profileDetails!["age"] as? Int
                
                
                let picture = (profileDetails!["picture"]!.object(forKey: "data")! as AnyObject).object(forKey: "url")! as? String
                let status: String? = "Your status is a particular interest or upcoming event that you wish to share."
                
                
                
                /*  MOVED EVERYTHING FROM CreateUser() HERE  */
                if name != nil && age != nil /*&& interests != nil*/ && picture != nil && status != nil {
                    
                    let profile:[String:AnyObject] = ["name":name! as AnyObject,
                                                      "age":age! as AnyObject,
                                                      /*"interests":interests! as AnyObject,*/
                                                      "pictureURL":picture! as AnyObject,
                                                      "status":status as AnyObject]
                    
                    
                    if WishManager.sharedInstance.uid != nil {
                        WishManager.sharedInstance.createProfile(profile: profile,path: "users/\(WishManager.sharedInstance.uid!)")
                    } else {
                        print("uid is nil (UserCreator.swift)")
                    }
                    
                } else {
                    print("One or more of passed user data is nil (UserCreator.swift)")
                }
                
            
            } else {
                print("profileDetails is nil (UserCreator.swift)")
            }
        })
    
    }
    
    /* Method for creating user */
    func createUser() {
        
        if self.name != nil && self.age != nil && self.interests != nil && self.picture != nil && self.status != nil {
        
            let profile:[String:AnyObject] = ["name":self.name! as AnyObject,
                                              "age":self.age! as AnyObject,
                                              "interests":self.interests! as AnyObject,
                                              "pictureURL":self.picture! as AnyObject,
                                              "status":self.status! as AnyObject]
            
            
            if WishManager.sharedInstance.uid != nil {
                WishManager.sharedInstance.createProfile(profile: profile, path: "users/\(WishManager.sharedInstance.uid!)")
            } else {
                print("uid is nil (UserCreator.swift)")
            }
            
        } else {
            print("One or more of passed user data is nil (UserCreator.swift)")
        }
        
    }
    
}
