//
//  WishManager.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-02-02.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import Foundation
import Firebase

/* ALL TASKS WILL GO THROUGH THIS CLASS. FUNCTIONS AS AN API BETWEEN THE DIFFERENT OPERATIONS (THE OTHER APIs) AND VIEW CONTROLLER */

class WishManager {
    
    private let firebaseOperation: FirebaseOperation
    private let facebookOperation: FacebookOperation
    private let firebaseStorageOperation: FirebaseStorageOperations
    private let FIREBASE_BASE_URL: String
    
    var uid: String?
    
    init() {
    
        uid = ""
        FIREBASE_BASE_URL = "https://wishter-f0c10.firebaseio.com/"
        firebaseOperation = FirebaseOperation(url: FIREBASE_BASE_URL)
        facebookOperation = FacebookOperation(permissions: nil)
        firebaseStorageOperation = FirebaseStorageOperations(st: "Heh")
    }
    
    class var sharedInstance: WishManager {
        
        struct Singleton {
            static let instance = WishManager()
        }
        
        return Singleton.instance
    }
    
    //MARK: Firebase SDK
    
    /* Listen for user auth updates. Used when finding out if user is signed in or not */
    func userAuthStatusWithBlock(completion: @escaping (_ authData: FIRUser?) -> Void) {
        
        firebaseOperation.authStatusUpdateWithBlock({
            (authData) in
            
            if authData != nil {
                self.uid = authData!.uid
            } else {
                print("authData is nil (UserManager.swift)")
            }
            completion(authData)
        })
    }
    
    /* Read data at specific path */
    func readDataAtPath(path: String, eventType: FIRDataEventType, completion: @escaping (_ data: FIRDataSnapshot?) -> Void) {
        firebaseOperation.readPath(path, eventType: eventType, completion: {
            (data) in
            completion(data)
        })
    }
    
    /* Get user (self) wishes and wish images */
    func getMyWishes(userID: String?, completion: @escaping (NSDictionary?) -> Void) {
        
        if userID != nil {
            
            /* Get everything in wish except image */
            firebaseOperation.readPath("/users/\(userID!)/wishes", eventType: .childAdded, completion: {
                (wishData) in
                
                if wishData != nil {
                    
                    /* Get image for each wish */
                    
                    // Get path for image
                    let imagePath: String = ((wishData?.value as? NSDictionary)?["imagePath"] as? String)!
                    
                    // Request image
                    self.firebaseStorageOperation.downloadFromPath(path: imagePath, completion: {
                        (image) in
                        if image != nil {
                            
                            /* Construct final NSDictionary to pass back */
                            let finalDictionary: NSDictionary = ["wishData":wishData!,"image":UIImage(data: image! as Data)!]
                            
                            completion(finalDictionary)
                            
                        } else {
                            print("image is nil (WishManager.swift)")
                        }
                    })
                    
                } else {
                    print("wishData is nil (WishManager.swift)")
                }
                
            })
            
        } else {
            print("userID is nil (WishManager.swift)");
        }
        
    }
    
    func unAuth() {
        firebaseOperation.unAuth()
    }
    
    func createProfile(profile: [String:AnyObject], path: String) {
        self.firebaseOperation.updatePath(path, autoID: false, data: profile)
    }
    
    func addWishTo(user userID: String?, wishDictionary dictionary: [String:Any]) {
        if userID != nil {
            self.firebaseOperation.writeToPath("/users/\(userID!)/wishes", autoid: true, data: dictionary)
        } else {
            print("userID is nil (WishManager.swift)")
        }
    }
    
    func addWishImageToUser(image: UIImage, user: String) -> String {
        
        /* Generate path */
        let randomString = self.randomString(length: 30)
        let path: String = "/wishImages/\(user)/\(randomString)"
        
        self.uploadImageToPath(image: image, path: path)
        
        return "\(path)/userWishes"
    }
    
    /* Returns each wish individually for passed-in user */
    func getUserWishes(userID: String?, completion: @escaping (NSDictionary?) -> Void) {
        if userID != nil {
            self.readDataAtPath(path: "/users/\(userID!)/wishes", eventType: .childAdded, completion: {
                (user) in
                if user != nil {
                    completion(user!.value as! [String:AnyObject] as NSDictionary)
                } else {
                    print("user is nil (WishManager.swift)")
                }
            })
        }
    }
    
    func getOtherUsers(completion: @escaping (AnyObject?) -> Void) {
        self.readDataAtPath(path: "/users", eventType: .childAdded, completion: {
            (user) in
            if user != nil {
                completion(user!)
            } else {
                print("user is nil (WishManager.swift)")
            }
        })
    }
    
    
    //MARK: Facebook SDK
    
    /* Get Facebook profile name, age and picture */
    func getFacebookProfileDetails(completion: @escaping ([String:AnyObject]?) -> Void) {
        self.facebookOperation.getProfilePicture {
            (picture) in
            self.facebookOperation.getName({
                (name) in
                self.facebookOperation.getAge({
                    (age) in
                    if picture != nil && name != nil && age != nil {
                        completion(["picture":picture! as AnyObject, "name":name! as AnyObject, "age":age!])
                    } else {
                        completion(nil)
                    }
                })
            })
        }
    }
    
    func gefbtName(completion: @escaping ([String:AnyObject]?) -> Void) {
        self.facebookOperation.getName({
            (name) in
            completion(name as [String : AnyObject]?)
        })
    }
    
    func getFacebookFriends(completion: @escaping (AnyObject?) -> Void) {
        self.facebookOperation.getFriends({
            (result) in
            completion(result as AnyObject?)
        })
    }
    
    //MARK: Firebase storage
    func uploadImageToPath(image: UIImage, path: String) {
        if let data = UIImagePNGRepresentation(image) as Data? {
            firebaseStorageOperation.uploadToPath(path: path, data: data as NSData)
        } else {
            print("cannot turn UIImage into NSData (WishManager.swift)")
        }
    }
    
    //MARK: Private Helper Methods
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}
