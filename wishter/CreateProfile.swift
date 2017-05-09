//
//  CreateProfile.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-14.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//


/* Handles communication between ViewControllers and FirebaseOperation */

import Foundation

class CreateProfile {
    
    /* Properties */
    let path: String!
    let baseURL: String!
    let firebaseOperation: FirebaseOperation
    
    init(baseURL: String) {
        self.baseURL = baseURL
        self.path = nil
        self.firebaseOperation = FirebaseOperation(url: self.baseURL)
    }
    
    
    func create(_ profile: [String:AnyObject], path: String) {
        self.firebaseOperation.updatePath(path, autoID: false, data: profile)
    }
    
    func updateUserName(_ userID: String?, newName: String?) {
        if userID != nil && newName != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["name":newName! as AnyObject])
        } else {
            print("userID or newName is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserAge(_ userID: String?, newAge: Int?) {
        if userID != nil && newAge != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["age":newAge! as AnyObject])
        } else {
            print("userID or newAge is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserPreferencesAge(_ userID: String?, newAgePref: [Int]?) {
        if userID != nil && newAgePref != nil {
            self.firebaseOperation.updatePath("users/\(userID!)/preferences", autoID: false, data: ["age":newAgePref! as AnyObject])
        } else {
            print("userID or newAgePref is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserPreferencesDistance(_ userID: String?, newDistancePref: Int?) {
        if userID != nil && newDistancePref != nil {
            self.firebaseOperation.updatePath("users/\(userID!)/preferences", autoID: false, data: ["distance":newDistancePref! as AnyObject])
        } else {
            print("userID or newDistancePref is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserStatus(_ userID: String?, status: String?) {
        if userID != nil && status != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["status":status! as AnyObject])
        } else {
            print("userID or status is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserInterests(_ userID: String?, interests: [String]?) {
        if userID != nil && interests != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["interests":interests! as AnyObject])
        } else {
            print("userID or interests is nil (CreateProfile.swift)")
        }
    }
    
    


}
