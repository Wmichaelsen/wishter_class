//
//  FirebaseOperation.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-14.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

//MARK: -
//MARK: Description

//  Class performs all communication with Firebase database
//  ALL database arrends should go through here

//MARK: -

import Foundation
import Firebase
import FirebaseAuth

class FirebaseOperation {

    let refURL: String
    
    init(url: String) {
        refURL = url
    }
    
    func unAuth() {
        try! FIRAuth.auth()!.signOut()
    }
    
    func authenticateWithProvider(provider: String, token: String, credential: FIRAuthCredential, withCompletion: (authData: FIRUser?, error: NSError?) -> Void) {
        
        FIRAuth.auth()?.signInWithCredential(credential) {
            (user, error) in
            withCompletion(authData: user, error: error)
            
        }

//        FIRAuth.auth()?.signInWithCustomToken(token, completion: {
//            (authdata, error) in
//            withCompletion(authData: authdata, error: error)
//        })
        
//        ref.authWithOAuthProvider(provider, token: token, withCompletionBlock: {
//            (error, authData) in
//            withCompletion(firebaseError: error, authData: authData)
//            
//        })
        
    }
    
    func writeToPath(path: String?, autoid: Bool, data: [String:AnyObject]) {
        let ref = FIRDatabase.database().reference()
        
        if path != nil {
            
            let pathe = ref.child(path!)
            
            if autoid {
                pathe.childByAutoId().setValue(data)
            } else {
                pathe.setValue(data)
            }
        } else {
                        
            if autoid {
                ref.childByAutoId().setValue(data)
            } else {
                ref.setValue(data)
            }
            
        }
        
        
        
    }
    
    func updatePath(path: String, autoID: Bool, data: [String:AnyObject]?) {

        let ref = FIRDatabase.database().reference()
        let path = ref.child(path)
        
        if autoID {
            path.childByAutoId().updateChildValues(data!)
        } else {
            path.updateChildValues(data!)
        }
    }
    
    func readPath(path: String?, eventType: FIRDataEventType, completion: (data: FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()

        if path != nil {
            ref.child(path!).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(data: snapshot)
            })
        } else {
            
            /* Listens for change on path and notifies with completion. Triggered once with all child in NSDictionary or NSArray or similar datatypes */
            ref.observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(data: snapshot)
            })
        }
    }
    
    func readPathOnce(path: String?, eventType: FIRDataEventType, completion: (data: FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        
        if path != nil {

            ref.child(path!).observeSingleEventOfType(eventType, withBlock: {
                (snapshot) in
                completion(data: snapshot)
            })
        } else {
            ref.observeSingleEventOfType(eventType, withBlock: {
                (snapshot) in
                completion(data: snapshot)
            })
        }
    }
    
    func stopListening() {
        let ref = FIRDatabase.database().reference()
        
        ref.removeAllObservers()
    }
    
    /* Listen for updates on auth status for user. Used when finding out if user is signed in or not */
    func authStatusUpdateWithBlock(completion: (authData: FIRUser?) -> Void) {
       // let ref = FIRDatabase.database().reference()
        
        FIRAuth.auth()!.addAuthStateDidChangeListener({
            (auth, user) in
            completion(authData: user)
        })
        
//        ref.observeAuthEventWithBlock({
//            (authData) in
//            completion(authData: authData)
//        })
    }
    
    func queryWithKeyAtPathWithBlock(path: String?, key: String, eventType: FIRDataEventType, completion: (snapshot: FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()

        if path != nil {
        
            ref.child(path!).queryOrderedByChild(key).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(snapshot: snapshot)
            })

        } else {
            ref.queryOrderedByChild(key).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(snapshot: snapshot)
            })
        }
    }
    
    func queryWithKey(key: String?, atPath path: String?, withEventType eventType: FIRDataEventType, withLast numberOfObjects: UInt, completion: (FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        
        if path != nil && key != nil {
            ref.child(path!).queryOrderedByChild(key!).queryLimitedToLast(numberOfObjects).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(snapshot)
            })
        } else if path == nil && key != nil {
            ref.queryOrderedByChild(key!).queryLimitedToLast(numberOfObjects).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(snapshot)
            })
        } else if path == nil && key == nil {
            ref.queryLimitedToLast(numberOfObjects).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(snapshot)
            })

        } else if path != nil && key == nil {
            ref.child(path!).queryLimitedToLast(numberOfObjects).observeEventType(eventType, withBlock: {
                (snapshot) in
                completion(snapshot)
            })
        }
        
    }
  
    
    
    

}