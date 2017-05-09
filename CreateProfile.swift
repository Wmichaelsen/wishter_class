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
    let profile: Profile!
    let path: String!
    let baseURL: String!
    let firebaseOperation: FirebaseOperation
    
    init(baseURL: String) {
        self.profile = nil
        self.baseURL = baseURL
        self.path = nil
        self.firebaseOperation = FirebaseOperation(url: self.baseURL)
    }
    
    
    func create(profile: [String:AnyObject], path: String) {
        self.firebaseOperation.updatePath(path, autoID: false, data: profile)
    }
    
    func updateUserName(userID: String?, newName: String?) {
        if userID != nil && newName != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["name":newName!])
        } else {
            print("userID or newName is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserAge(userID: String?, newAge: Int?) {
        if userID != nil && newAge != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["age":newAge!])
        } else {
            print("userID or newAge is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserPreferencesAge(userID: String?, newAgePref: [Int]?) {
        if userID != nil && newAgePref != nil {
            self.firebaseOperation.updatePath("users/\(userID!)/preferences", autoID: false, data: ["age":newAgePref!])
        } else {
            print("userID or newAgePref is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserPreferencesDistance(userID: String?, newDistancePref: Int?) {
        if userID != nil && newDistancePref != nil {
            self.firebaseOperation.updatePath("users/\(userID!)/preferences", autoID: false, data: ["distance":newDistancePref!])
        } else {
            print("userID or newDistancePref is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserStatus(userID: String?, status: String?) {
        if userID != nil && status != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["status":status!])
        } else {
            print("userID or status is nil (CreateProfile.swift)")
        }
    }
    
    func updateUserInterests(userID: String?, interests: [String]?) {
        if userID != nil && interests != nil {
            self.firebaseOperation.updatePath("users/\(userID!)", autoID: false, data: ["interests":interests!])
        } else {
            print("userID or interests is nil (CreateProfile.swift)")
        }
    }
    
    


}