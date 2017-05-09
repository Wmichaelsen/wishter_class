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
    var agePreference: [Int]?
    var distancePreference: Int?
    var status: String?
    
    private let DEFAULT_AGE_PREFERENCE: [Int]? = [25,40]
    private let DEFAULT_DISTANCE_PREFERENCE: Int? = 20
    
    /* Use this method to create user with specific data */
    init(withName name: String?, age: Int?, interests: [String]?, picture: String?, agePreference: [Int]?, distacePreference: Int?, status: String?) {
        
        self.name = name
        self.age = age
        self.interests = interests
        self.picture = picture
        self.agePreference = agePreference
        self.distancePreference = distacePreference
        self.status = status
    }
    
    /* Use this method to create user with data from Facebook */
    init() {
        
        UserManager.sharedInstance.getFacebookProfileDetails({
            (profileDetails) in
            
            if profileDetails != nil {
        
                /* Gather all data and create profile */
                self.name = profileDetails!["name"]?.objectForKey("name") as? String
                self.age = profileDetails!["age"] as? Int
                
                if UserManager.sharedInstance.selectedCategories != nil {
                    self.interests = UserManager.sharedInstance.selectedCategories! as NSArray as? [String]
                } else {
                    print("selecterCategories is nil (UserCreator.swift)")
                }
                self.picture = profileDetails!["picture"]!.objectForKey("data")!.objectForKey("url")! as? String
                self.agePreference = self.DEFAULT_AGE_PREFERENCE
                self.distancePreference = self.DEFAULT_DISTANCE_PREFERENCE
                self.status = "Your status is a particular interest or upcoming event that you wish to share."
                
                self.createUser()
            
            } else {
                print("profileDetails is nil (UserCreator.swift)")
            }
        })
    
    }
    
    /* Method for creating user */
    func createUser() {
        
        if self.name != nil && self.age != nil && self.interests != nil && self.picture != nil && self.agePreference != nil && self.distancePreference != nil && self.status != nil {
        
            let profile:[String:AnyObject] = ["name":self.name!,
                                              "age":self.age!,
                                              "interests":self.interests!,
                                              "preferences":["age":self.agePreference!, "distance":self.distancePreference!],
                                              "pictureURL":self.picture!,
                                              "status":self.status!]
            
            
            if UserManager.sharedInstance.uid != nil {
                UserManager.sharedInstance.createProfileAtPath("users/\(UserManager.sharedInstance.uid!)", profile: profile)
            } else {
                print("uid is nil (UserCreator.swift)")
            }
            
        } else {
            print("One or more of passed user data is nil (UserCreator.swift)")
        }
        
    }
    
}